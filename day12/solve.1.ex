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
            {perimeter, area, seen} = fill(input, coord, seen)
            type = access(input, coord)
            {seen, [{perimeter, area, type} | regions]}
          end
      end

    for {perimeter, area, type} <- Enum.reverse(regions), reduce: 0 do
      acc ->
        IO.puts("#{<<type>>} | Perimeter: #{perimeter}, Area: #{area}")
        acc + perimeter * area
    end
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

  @spec neighbors(input(), coord()) :: list(coord)
  defp neighbors(input, {x, y}) do
    val = access(input, {x, y})

    for neighbor <- [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}],
        access(input, neighbor) == val,
        do: neighbor
  end

  @spec fill(input(), coord(), MapSet.t(coord())) :: {integer(), integer(), MapSet.t(coord())}
  defp fill(input, coord, seen) do
    for neighbor <- neighbors(input, coord),
        reduce: {4, 1, MapSet.put(seen, coord)} do
      {perimeter, area, seen} ->
        if MapSet.member?(seen, neighbor) do
          {perimeter - 1, area, seen}
        else
          {dp, da, seen} = fill(input, neighbor, seen)
          {perimeter + dp - 1, area + da, seen}
        end
    end
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> List.to_tuple()

IO.inspect(Solution.solve(input))
