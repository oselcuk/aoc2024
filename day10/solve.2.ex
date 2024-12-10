require ExUnit.Assertions

defmodule Solution do
  def solve(input) do
    last = tuple_size(input) - 1

    for i <- 0..last, j <- 0..last, elem = access(input, {i, j}), elem == ?0, reduce: 0 do
      acc -> acc + solve(input, [{i, j}], ?0)
    end
  end

  defp access(input, {x, y}) do
    len = tuple_size(input)

    if x < 0 or y < 0 or x >= len or y >= len do
      nil
    else
      input |> elem(x) |> elem(y)
    end
  end

  defp neighbors(input, {x, y}) do
    target = access(input, {x, y}) + 1

    for next <- [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}],
        access(input, next) == target,
        do: next
  end

  defp solve(_, nodes, ?9), do: length(nodes)

  defp solve(input, nodes, elem) do
    solve(
      input,
      nodes |> Enum.map(&neighbors(input, &1)) |> List.flatten(),
      elem + 1
    )
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&List.to_tuple(String.to_charlist(&1)))
  |> List.to_tuple()

ExUnit.Assertions.assert(tuple_size(input) == tuple_size(elem(input, 0)))

IO.inspect(Solution.solve(input))
