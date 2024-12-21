Mix.install([:memoize])

defmodule Solution do
  use Memoize
  import Bitwise

  defmemo iterate(a) do
    b = a &&& 0b111
    b = bxor(b, 0b110)
    c = a >>> b
    b = bxor(b, c)
    b = bxor(b, 0b111)
    b &&& 0b111
  end

  def solve([], previous), do: previous

  def solve([target | rest], previous) do
    next = previous <<< 3

    0..7
    |> Stream.map(&(&1 ||| next))
    |> Stream.filter(&(iterate(&1) == target))
    |> Stream.map(&solve(rest, &1))
    |> Stream.drop_while(&(!&1))
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end
end

[_, program] = IO.read(:eof) |> String.split("\n\n")

targets =
  String.split(program, " ")
  |> List.last()
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
  |> Enum.reverse()
  |> IO.inspect()

Solution.solve(targets, 0)
|> IO.inspect()
