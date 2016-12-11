
## Identity function
```JavaScript
const Box = x => ({
  map: f => Box( f( x ) ),
  fold: f => f( x )
})

Box( 7 )
  .map( n => n * 10 ) // Box( 70 )
  .map( n => n + 1 ) // Box( 71 )
  .fold( n => n ) // 71
```

```Ruby
class Box

  def initialize( val )
    @val = val
  end

  def map( &block )
    Box.new( block.( @val ) )
  end

  def fold( &block )
    block.( @val )
  end

end

Box.new( 5 )
  .map { |n| n * 10 } # Box( 50 )
  .fold { |n| n + 1 } # 51
```

```Elixir
defmodule Box do
  defstruct [ :value ]

  # map
  def %Box{ value: val } ~>> func do
    %Box{ value: apply( func, [ val ] ) }
  end

  # fold
  def %Box{ value: val } ~> func do
    apply( func, [ val ] )
  end
end

defmodule Example do
  import Box

  def run do
    %Box{ value: 5 }
      ~>> fn n -> n * 10 end # %Box{ value: 50 }
      ~>> fn n -> n + 1 end # %Box{ value: 51 }
      ~> fn n -> n end # 51
    |> IO.inspect
  end
end
```

## Maybe function
```JavaScript
const Something = x => ({
  map: f => Something( f( x ) ),
  fold: ( f, g ) => g( x )
})

const Nothing = x => ({
  map: f => Nothing( x ),
  fold: ( f, g ) => f( x )
})

const fromNullable = x =>
  x == null ? Nothing( x ) : Something( x )


const colours = name =>
  fromNullable( ({ red: "#f00", green: "#0f0", blue: "#00f" })[ name ] )

colours( "blue" )
  .map( c => c.slice( 1 ) ) // when no colour, Nothing skips applying the anon.fn, no error
  .fold(
    e => "no colour found", // Nothing runs the fold( f, g ), f, for error handling
    c => c.toUpperCase() // Something runs the fold( f, g ), g, for normal operation
    )
```

```Ruby
class Maybe

  attr_reader :val

  def initialize( val )
    @val = val == nil ? Nothing.new( nil ) : Just.new( val )
  end

  def map( &block )
    val.map( &block )
  end

  def fold( &block )
    val.fold( &block )
  end

  Nothing = Struct.new( :value ) do
    def map( &block )
      self
    end

    def fold( &block )
      nil 
    end
  end

  Just = Struct.new( :value ) do
    def map( &block )
      Just.new( block.( self.value ) )
    end

    def fold( &block )
      block.( self.value )
    end
  end

end

Maybe.new( 5 )
  .map { |n| n * 10 } # <struct Just value = 50>
  .fold { |n| n + 1 } # 51
```

```Elixir
defmodule Maybe do

  defmodule Just do
    defstruct [ :value ]
  end

  defmodule Nothing do
    defstruct []
  end

  def return( val ) when is_nil( val ), do: %Nothing{}
  def return( val ), do: %Just{ value: val }

  def bind( %Just{ value: value }, func ) do
    apply( func, [ value ] )
    |> return
  end

  def bind( %Nothing{}, _ ) do
    %Nothing{}
  end

  @doc """
  Infix operator so that chaining `bind` looks prettier
  """
  def val ~>> func do
    bind( val, func )
  end

end


defmodule Maybe.Example do
  import Maybe

  def run do
    IO.inspect return( nil ) # %Nothing{}
    IO.inspect return( 5 ) # %Just{ value: 5 }

    colours = fn name -> return( %{red: "#f00", green: "#0f0", blue: "#00f"}[name] ) end
    get_code = fn "#" <> code -> code end
    upcase = fn str -> String.upcase( str ) end

    IO.inspect( colours.( :green ) ~>> get_code ~>> upcase ) # %Just{ value: "0F0" }
    IO.inspect( colours.( :lilac ) ~>> get_code ~>> upcase ) # %Nothing{}
  end

end
```























