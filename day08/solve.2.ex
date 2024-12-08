defmodule Solution do
  @spec solve(list(String.t())) :: integer()
  def solve(matrix) do
    nodes =
      for {row, i} <- Enum.with_index(matrix),
          {c, j} <- Enum.with_index(String.to_charlist(row)),
          c != ?.,
          reduce: Map.new() do
        acc -> Map.update(acc, c, [{i, j}], &[{i, j} | &1])
      end

    # Assume square matrix
    dim = length(matrix)
    valid = fn {x, y} -> x >= 0 and x < dim and y >= 0 and y < dim end

    antinodes = fn {x1, y1}, {x2, y2} ->
      dx = x1 - x2
      dy = y1 - y2

      Stream.concat(
        Stream.iterate({x1, y1}, fn {x, y} -> {x + dx, y + dy} end) |> Stream.take_while(valid),
        Stream.iterate({x2, y2}, fn {x, y} -> {x - dx, y - dy} end) |> Stream.take_while(valid)
      )
    end

    for {_, locations} <- nodes,
        a <- locations,
        b <- locations,
        a != b,
        antinode <- antinodes.(a, b),
        valid.(antinode),
        uniq: true,
        do: antinode
  end
end

IO.read(:eof)
|> String.split("\n", trim: true)
|> Solution.solve()
|> Enum.count()
|> IO.inspect()
