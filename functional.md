# Source
Ideas gathered, combined, and copied from:
[Brian Lonsdorf's tutorial on egghead.io](https://egghead.io/lessons/javascript-linear-data-flow-with-container-style-types-box)
[Izaak Schroeder at metalab](https://github.com/metalabdesign/effects-workshop)

# Functors
Laws of functors
```
fx.map( f ).map( g ) == fx.map( x => g( f(x) ) )
fx.map( id ) == id( fx )
```

# Identity function
## JavaScript
```JavaScript
const Box = x => ({
  map: f => Box( f( x ) ),
  fold: f => f( x )
})

const LazyBox = g => ({
  fold: f => f( g() ),
  map: f => LazyBox( () => f( g() ) )
})

Box( 7 )
  .map( n => n * 10 ) // Box( 70 )
  .map( n => n + 1 ) // Box( 71 )
  .fold( n => n ) // 71
```

## Ruby
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

## Elixir
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

# Maybe function
## JavaScript
```JavaScript
const Right = x => ({
  map: f => Right( f( x ) ),
  fold: ( f, g ) => g( x )
})

const Left = x => ({
  map: f => Left( x ),
  fold: ( f, g ) => f( x )
})

const fromNullable = x =>
  x == null ? Left( x ) : Right( x )


const colours = name =>
  fromNullable( ({ red: "#f00", green: "#0f0", blue: "#00f" })[ name ] )

colours( "blue" )
  .map( c => c.slice( 1 ) ) // when no colour, Left skips applying the anon.fn, no error
  .fold(
    e => "no colour found", // Left runs the fold( f, g ), f, for error handling
    c => c.toUpperCase() // Right runs the fold( f, g ), g, for normal operation
    )
```

## Ruby
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

## Elixir
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

  def %Nothing{} ~> _, do: nil

  def %Just{ value: val } ~> func do
    apply( func, [ val ] )
  end

end


defmodule Maybe.Example do
  import Maybe

  def run do
    colours = fn name -> return( %{red: "#f00", green: "#0f0", blue: "#00f"}[name] ) end
    get_code = fn "#" <> code -> code end

    IO.inspect(
      colours.( :green )
        ~>> get_code # %Just{ value: "0f0" }
        ~> &String.upcase/1 # "0F0"
    )

    IO.inspect(
      colours.( :lilac )
        ~>> get_code # %Nothing{}
        ~> &String.upcase/1 # nil
    )
  end

end

Maybe.Example.run
```

# Semigroups
A value type that can concat to other values of the same type.

## JavaScript
```JavaScript
  const Sum = x => ({
    x,
    concat: { { x: y } ) => Sum( x + y )
  })
  Sum.empty = () => Sum( 0 )


  const Product = x => ({
    x,
    concat: { { x: y } ) => Product( x * y )
  })
  Product.empty = () => Sum( 1 )


  const Any = x => ({
    x,
    concat: { { x: y } ) => Any( x || y )
  })
  Any.empty = () => Any( false )


  const All = x => ({
    x,
    concat: { { x: y } ) => All( x && y )
  })
  All.empty = () => All( true )


  const Max = x => ({
    x,
    concat: { { x: y } ) => Max( x > y ? x : y )
  })
  Max.empty = () => Max( -Infinity )

  const Min = x => ({
    x,
    concat: { { x: y } ) => Min( x < y ? x : y )
  })
  Min.empty = () => Min( Infinity )


  const First = either => ({
    fold: f => f( either ),
    concat: o => either.isLeft ? o : First( either )
  })
  First.empty = () => First( Left() )

  const find = ( list, f ) =>
    List( list )
      .foldMap( x => First( f( x ) ? Right( x ) : Left() ), First.empty() )
      .fold( x => x )

  find( [ 3, 4, 5, 6, 7 ], x => x > 4 ) // Right( 5 )


  const Right = x => ({
    fold: ( _, g ) => g( x ),
    map: f => Right( f( x ) ),
    concat: o => o.fold(
      e => Left( e ),
      r => Right( x.concat( r ) )
    )
  })

  const Left = x => ({
    fold: ( f, _ ) => f( x ),
    map: _ => Left( x ),
    concat: _ => Left( x )
  })


  const Fn = f => ({
    fold: f,
    concat: o => Fn( x => f( x ).concat( o.fold( x ) ) )
  })


  const Pair = ( x, y ) => ({
    x, 
    y, 
    concat: ( { x: x1, y: y1 } ) => Pair( x.concat( x1 ), y.concat( y1 ) )
  })
```

