defmodule Solution do
  import Bitwise

  # def run(a) do
  #   Stream.iterate({a, 0}, &iterate/1)
  #   |> Stream.drop_while(fn {a, _} -> a > 0 end)
  #   |> Stream.take(1)
  #   |> Enum.to_list()
  #   |> hd()
  #   |> elem(1)
  # end

  def iterate(a) do
    b = a &&& 0b111
    b = bxor(b, 0b110)
    c = a >>> b
    b = bxor(b, c)
    b = bxor(b, 0b111)
    a = a >>> 3
    {a, b &&& 0b111}
  end

  def solve(solutions, targets, previous, bitmask \\ (1 <<< 7) - 1)
  def solve(_, [], _, _), do: 0

  def solve(solutions, [target | rest], previous, bitmask) do
    # IO.inspect(target, label: "target")
    return = previous &&& 0b111
    suffix = previous >>> 3

    results =
      elem(solutions, target)
      |> Stream.filter(fn option -> (option &&& bitmask) == suffix end)
      |> Stream.map(&solve(solutions, rest, &1))
      |> Stream.filter(& &1)
      |> Stream.take(1)
      |> Enum.to_list()

    case results do
      [] -> nil
      [result] -> result <<< 3 ||| return
    end
  end

  def print_chunked(num) do
    len = ceil(:math.log2(num) / 3) * 3

    Integer.to_string(num, 2)
    |> String.pad_leading(len, "0")
    |> String.to_charlist()
    |> Enum.chunk_every(3)
    |> Enum.reverse()
    |> Enum.intersperse(" ")
    |> Enum.join()
    |> IO.puts()
  end
end

[_, program] = IO.read(:eof) |> String.split("\n\n")

targets =
  String.split(program, " ")
  |> List.last()
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

solutions =
  0..1023
  |> Stream.map(&Solution.iterate/1)
  |> Stream.with_index()
  |> Enum.reduce(
    for(_ <- 0..7, do: []) |> List.to_tuple(),
    fn {{_, res}, input}, acc ->
      with options = elem(acc, res), do: put_elem(acc, res, [input | options])
    end
  )

out =
  Solution.solve(solutions, targets, 0, 0)
  |> IO.inspect()

Solution.print_chunked(37_293_246)
Solution.print_chunked(out)

# for target <- targets, reduce: 0 do
#   leading_bits ->
#     0
# end
