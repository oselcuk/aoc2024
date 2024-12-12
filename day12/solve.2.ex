defmodule Solution do
  @type coord :: {integer(), integer()}
  @type input :: tuple()

  @spec solve(input()) :: integer()
  def solve(input) do
    dim = tuple_size(input) - 1

    {_, regions} =
      for x <- 0..dim, y <- 0..dim, reduce: {MapSet.new(), []} do
        {seen, regions} ->
          coord = {x, y}

          if MapSet.member?(seen, coord) do
            {seen, regions}
          else
            seen_total = fill(input, coord, seen)
            seen_new = MapSet.difference(seen_total, seen)
            {seen_total, [seen_new | regions]}
          end
      end

    for plots <- Enum.reverse(regions), reduce: 0 do
      acc -> acc + calculate_cost(plots)
    end
  end

  @spec calculate_cost(MapSet.t(coord())) :: integer()
  defp calculate_cost(plots) do
    area = MapSet.size(plots)
    perimeter = count_corners(plots)
    [{x, y}] = Enum.take(plots, 1)
    IO.puts("#{x}:#{y}\t| Perimeter: #{perimeter}, Area: #{area}")
    perimeter * area
  end

  @spec count_corners(MapSet.t(coord())) :: integer()
  defp count_corners(plots) do
    for({x, y} <- plots, dx <- [0, 1], dy <- [0, 1], do: {x + dx, y + dy, dx * 2 + dy})
    |> Enum.reduce(Map.new(), fn {x, y, corner}, acc ->
      Map.update(acc, {x, y}, [corner], &[corner | &1])
    end)
    |> Enum.map(fn {_, corners} ->
      case corners do
        [a, b] when a + b == 3 -> 2
        _ -> length(corners) |> rem(2)
      end
    end)
    |> Enum.sum()
  end

  @spec access(input(), coord()) :: char() | nil
  defp access(input, {x, y}) do
    dim = tuple_size(input)

    if x >= 0 and x < dim and y >= 0 and y < dim do
      input |> elem(x) |> elem(y)
    else
      nil
    end
  end

  @spec neighbors(input(), coord()) :: list(coord())
  defp neighbors(input, {x, y}) do
    val = access(input, {x, y})

    for neighbor <- [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}],
        access(input, neighbor) == val,
        do: neighbor
  end

  @spec fill(input(), coord(), MapSet.t(coord())) :: MapSet.t(coord())
  defp fill(input, coord, seen) do
    for neighbor <- neighbors(input, coord),
        reduce: MapSet.put(seen, coord) do
      seen -> if MapSet.member?(seen, neighbor), do: seen, else: fill(input, neighbor, seen)
    end
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> List.to_tuple()

IO.inspect(Solution.solve(input))
