Basic types
  Value Types:
    Integers
      Decimal
      Hex
      Oct
      Binary
    Floats
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
    Lists
    Maps
    Binaries

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


Piping: |>
  # takes the output and makes it the first arg of the next func
  # if next func has args specified, they get pushed
  customers = DB.get("customers")
  ret = calc_tax.(customers, 2016)
  # can be written as:
  ret = DB.get("customers") |> calc_tax.(2016)
  
  # always wrap args/params in parenthesis
  ( 1..10 ) |> Enum.map( &( &1 * &2 ) )
