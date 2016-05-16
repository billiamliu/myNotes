Helpers:
  h # get a list of helpers

##############################################################
Basic types
##############################################################
  Value Types:
    Integers
      Decimal
      Hex
      Oct
      Binary
    Floats
    Strings
      "consecutive memory location string literal"
      'interger code points'
      [ 99, 97, 116 ] # 'cat', if all elements are string codepoints
    Atoms
      :fred
      :is_binary?
      :<>
      :===
      :"func/3"
      :var@2
    Ranges
      1..100
    Regex
      ~{regex}opts
        f: force match to start on first line
        g: support named groups
        i: case insensitive
        m: if multiline, ^ $ match start / end of lines, \A \z match start / end of whole string
        r: makes greedy matchers match as little as possible: * +
        s: allow . to match any newline chars
        u: unable unicode specfic patterns like \p
        x: extended mode, ignore whitespace and comments
      Regex.run ~r{[aeiou]}, "myInputStrHere"
        ["u"]
      Regex.scan ~r{[aeiou]}, "myInputStrHere"
        ["u", "e", "e"]
      Regex.split ~r{[aeiou]}, "myInputStrHere"
        ["myInp", "tStrH", "r"]
      Regex.replace ~r{[aeiou]}, "myInputStrHere", "*"
        "myInp*tStrH*r*"
  System Types: underlying EVM
    PIDs and ports
      PID: reference to a process
      port: reference to a resource
    References
      make_ref creates a globally unique reference
  Collection Types:
    Tuples: an ordered collection of values
      { 1, 2 }  { :ok, 42, "next" } { :error, :enoent }
      usually have 2 - 4 elements, anymore typically use maps and structs
      can be used in pattern matching { a, b } = { 1, 2 }
    Lists: eg. [ 1, 2, 3 ]
      finding random item is expensive ( scans n - 1 times )
      [ 1, 2 ] ++ [ 4, 5 ] # [ 1, 2, 4, 5 ]
      [ 1, 2, 3 ] -- [ 2 ] # [ 1, 3 ]
      1 in [ 1, 2, 3 ] # true
      Shortcuts:
        [ name: "Billiam", city: "Stockholm" ] # [ { :name, "Billiam " }, { :city, "Stockholm" } ]
    Maps: collection of key / value pairs
      %{ key => value, keyTwo => value }
      states = %{ "AL" => "Alabama", "OR" => "Oregon" }
      responses = %{ { :error, :enoent } => :fatal, { :error, :busy } => :retry }
      colors = %{ :red => 0xff0000, :green => 0x00f00 }
      Access using bracket syntax, or dot notation for atoms
    Binaries
      Binary literal:
        # pack successive integers into byets
        bin = << 1, 2 >>
        byte_size bin # 2
        bin = << 3 :: size(2), 5 :: size(4), 1 :: size(2) >>
        :io.format("~-8.2b~n", :binary.bin_to_list(bin))
        byte_size bin # 1

##############################################################
Match Operator
##############################################################

force existing variable to use its value in a match operation:
> a = 1
1
> a = 2
2
> ^a = 3
(MatchError)

copying data using [ head | tail ]
> a = [ 1, 2, 3 ]
[ 1, 2, 3]
> b = [ 5 | a ]
[ 5, 1, 2, 3 ]

##############################################################
Anon Func (invoke with . )
##############################################################

my_applier = func, val -> func( val )
my_applier.( IO.puts, "hello" )

open_handler = fn
  { :ok, file } -> "First line: #{ IO.read( file, :line ) }"
  { _, error } -> "Error: #{ :file.format_error( error ) }"
end

##############################################################
Shorthand
##############################################################

Enum.map [ 1, 2, 3 ], &( &1 * 10 )

##############################################################
With Expression: temp vars with local scope; "<-" operator for elegant error handling
##############################################################

lp = with { :ok, file }   = File.open( "hello.txt" ),
          content         = IO.read( file, :all ),
          :ok             = File.close( file ),
          [ _, uid, gid ] = Regex.run( ~r/_lp:.*?:(\d+):(\d+)/, content )
     do
       "Group: #{ gid }, User: #{ uid }"
     end

with [ a | _ ] <- [ 1, 2, 3 ], do: a
# 1
with [ a | _ ] <- nil,         do: a
# nil

Cannot use:
func = with
  params = thing
       do
         thing2
       end

Must be on the same line like above
Or with(
     params = thing
   do
     func
   end
)

##############################################################
Pattern Matching example (also named funcs - must be in modules)
##############################################################

defmodule MyMod do
  def factorial( 0 ), do: 1
  def factorial( n ), do: n * factorial( n - 1 )
end

##############################################################
Guard Clause
##############################################################

defmodule Factorial do
  def of( 0 ), do: 1
  def of( n ) when n > 0 do
    n * of( n - 1 )
  end
  # alternatively:
  # def of( n ) when n > 0 do: n * of( n - 1 )
end

Clauses:
- comparisons:
    ==, ===, etc
- boolean and negation
    or, and, not, ! # cannot use || &&
- math
- join:
    <>, ++ # left side must be a literal
- membership:
    thing in group
- type check
    is_atom
    is_binary
    is_bitstring
    is_boolean
    is_exception
    is_float
    is_function
    is_integer
    is_list
    is_map
    is_number
    is_pid
    is_port
    is_record
    is_reference
    is_tuple
- value check
    abs( num )
    bit_size( bitstring )
    byte_size( bitstring )
    div( num, num )
    elem( tuple, n )
    float( term )
    hd( list )
    length( list )
    node()
    node( pid | ref | port )
    rem( num, num )
    round( num )
    self()
    tl( list )
    trunc( num )
    tuple_size( tuple )

##############################################################
Default Params (named funcs)
##############################################################

defmodule Example do
  def func( p1, p2 \\ 2, p3 \\ 3, p4 ) do
    IO.inspect [ p1, p2, p3, p4 ]
  end
end

Example.func( "a", "b" ) # ["a", 2, 3, "b"]
Example.func( "a", "c", "b" ) # ["a", "c", 3, "b"]

Multi-clause defaults:

defmodule Params do
  def func( p1, p2 \\ 234 )

  def func( p1, p2 ) when is_list( p1 ) do
    "You said #{ p2 } with a list"
  end

  def func( p1, p2 ) do
    "You passed in #{ p1 } and #{ p2 }"
  end
end

IO.puts Params.func( 99 )             # you passed in 99 and 234
IO.puts Params.func( 99, "cat" )      # you passed in 99 and cat
IO.puts Params.func( [ 99 ] )         # you said 234 with a list
IO.puts Params.func( [ 99 ], "dog" )  # you said dog with a list

##############################################################
Private Functions: can only be callued within the module
##############################################################

defp priv( a ), do: true

##############################################################
Piping: |>
##############################################################

  # takes the output and makes it the first arg of the next func
  # if next func has args specified, they get pushed
  customers = DB.get("customers")
  ret = calc_tax.(customers, 2016)
  # can be written as:
  ret = DB.get("customers") |> calc_tax.(2016)

  # always wrap args/params in parenthesis
  ( 1..10 ) |> Enum.map( &( &1 * &2 ) )

##############################################################
Modules
##############################################################

# nested modules are an illusion (faked.with.dots.in.name)
# ergo can directly define a sub module

defmodule Mix.Tasks.Doctest do
  def run do
    thing
  end
end

# no particular relationship between modules Mix and Mix.Tasks.Doctest
# except for namespacing

Directives (lexically scoped)

Import: import Module [, only:|except: ] [name:arity]
eg: import List, only: [flatten: 1] # or [flatten: 1, duplicate: 2]
eg: import List, only: :functions # or :macros
flatten [ 5, [ 6, 7 ], 8 ]

Alias: alias My.Other.Module.Parser, as: Parser
Parser.parse()
# as: defaults to the last part of the module name, thus can:
alias My.Other.Module.{ Parser, Runner }
Runner.execute()

Require: # use other modules' macros

##############################################################
Module Attributes
##############################################################
# define at module top level
# somewhat similar to Ruby constants
defmodule Example do
  @author "Billiam Liu"
  def get_author do
    @author
  end
  @author "Billiam"
  def get_firstname do
    @author
  end
end

IO.puts "Example getting the author: #{ Example.get_author }"
IO.puts "After it's changed: #{ Example.get_firstname }"

# module names are atoms, can also invoke:
iex> to_string IO # "Elixir.IO"
iex> :"Elixir.IO".puts "hello" # "hello"

##############################################################
Erlang Functions
##############################################################
# Erlang convention: Variable, atom
# Elixir convention: variable, :atom
# example: call in Elixir the Erlang io.format
:io.format( "The number is ~3.1f~n", [ 3.345 ] )


##############################################################
Lists and Recursion
##############################################################
 [ head | tail ] = [ 1, 2, 3 ] # head = 1; tail = [ 2, 3 ]

 defmodule MyList do
   def leng( [] ), do: 0
   # head unused in func body, add "_" for compiler to ignore, or just use "_"
   def leng( [ _head | tail ] ), do: 1 + leng( tail )
   def square( [] ), do: []
   def square( [ head | tail ] ), do: [ head * head | square( tail ) ]
 end

# making .map()
defmodule MyList do
  def map( [], _func ), do: []
  def map( [ head | tail ], func ), do: [ func.( head ) | map( tail, func ) ]
end
# invoke with shorthand
MyList.map [ 1, 2, 3, 4 ], fn ( n ) -> n * n end
MyList.map [ 1, 2, 3, 4 ], &( &1 * &1 )

# maintain an invariant
defmodule MyList do
  def sum( list ), do: _sum( list, 0 ) # initial sum of 0

  defp _sum( [], total ), do: total
  defp _sum( [ head | tail ], total ), do: _sum( tail, head + total )
end

defmodule MyList do
  def reduce( [], value, _ ), do: value
  def reduce( [ head | tail ], value, func ) do
    reduce( tail, func.( head, value ), func )
  end
end
MyList.reduce( [1, 3, 5, 7 ], 0, &( &1 + &2 ) )

##############################################################
Complex List Patterns
##############################################################

# use the join operator `|` to match multiple values
defmodule Swap do
  def swap_two( [] ), do: []
  def swap_two( [ a, b | tail ] ), do: [ b, a | swap( tail ) ]
  def swap_two( [ _ ] ), do: raise "Can't swap two on odd lengths"
end

# sample real life example
defmodule WeatherHistory do
  def for_location( [], _target_loc ), do: [] # end of recursion
  def for_location( [ [time, target_loc, temp, rain ] | tail ], target_loc ) do
    [ [ time, target_loc, temp, rail ] | for_location( tail, target_loc ) ]
  end
  def for_location( [ _ | tail ], target_loc ), do: for_location( tail, target_loc )
end

# clean up because we only care about location
defmodule WeatherHistory do
  def for_location( [], _target_loc ), do: [] # end of recursion
  def for_location( [ head = [ _, target_loc, _, _ ] | tail ], target_loc ) do # matches 4-ele-array to head
    [ head | for_location( tail, target_loc ) ] # pass `head` instead of the 4-ele-array with things we don't care about
  end
  def for_location( [ _ | tail ], target_loc ), do: for_location( tail, target_loc )
end

##############################################################
List Module
##############################################################

# concat
[1, 2, 3] ++ [4, 5, 6] # [1, 2, 3, 4, 5, 6]

# flatten
List.flatten [ [ [1], 2 ], [3, 4], 5 ] # [1, 2, 3, 4, 5]

# Folding (like reduce, but can choose direction)
List.foldl( [1, 2, 3], "", fn value, acc -> "#{value}(#{acc})" end) # "3( 2( 1() ) )"
List.foldr( [1, 2, 3], "", fn value, acc -> "#{value}(#{acc})" end) # "1( 2( 3() ) )"

# Update at `n`, expensive
List.replace_at( [1, 2, 3], 2, "hello" ) # [1, 2, "hello"]

# Accessing Tuples
db = [ { :name, "Billiam" }, { :likes, "Elixir" }, { :where, "Vancouver", "Canada" } ]
> List.keyfind( db, "Vancouver", 1 ) # { :where, "Vancouver", "Canada" }
> List.keyfind( db, "Canada", 2 ) # { :where, "Vancouver", "Canada" }
> List.keyfind( db, "Vancouver", 2 ) # nil
> List.keyfind( db, "Canada", 1, "Error: no city called Canada" ) # "Error: no city called Canada"
> db = List.keydelete( db, "Canada", 2 ) # [ name: "Billiam", likes: "Elixir" ]
> db = List.keyreplace( db, :name, 0, { :first_name, "Billiam" } ) # [ first_name: "Billiam", likes: "Elixir" ]

##############################################################
##############################################################

##############################################################
##############################################################
