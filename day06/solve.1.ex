defmodule Solution do
  def rotate_cw(matrix, {x, y}) do
    coords = {y, length(matrix) - x - 1}

    rotated =
      matrix
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.reverse/1)

    {rotated, coords}
  end

  def rotate_ccw(matrix, {x, y}) do
    coords = {length(matrix) - y - 1, x}

    rotated =
      matrix
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.reverse()

    {rotated, coords}
  end

  def access(matrix, {x, y}), do: (Enum.at(matrix, x) || []) |> Enum.at(y)

  def walk_row(row, pos) do
    {prefix, path} = Enum.split(row, pos)
    {walked, rest} = Enum.split_while(path, &(&1 != ?#))
    marked = Enum.map(walked, fn _ -> ?x end)
    {prefix ++ marked ++ rest, length(prefix) + length(marked) - 1}
  end

  def move(matrix, {x, _})
      when x == 0,
      do: matrix

  def move(matrix, {x, y}) do
    # matrix |> Enum.map(&IO.inspect/1)
    # IO.inspect({x, y}, label: "Position")
    {updated, stopped} = walk_row(Enum.at(matrix, x), y)
    marked = List.replace_at(matrix, x, updated)

    cond do
      matrix == marked ->
        :loop

      true ->
        coords = {x, stopped}
        {rmatrix, rcoords} = rotate_ccw(marked, coords)
        move(rmatrix, rcoords)
    end
  end
end

matrix =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_charlist/1)

start =
  for({line, i} <- Enum.with_index(matrix), j = Enum.find_index(line, &(&1 == ?^)), do: {i, j})
  |> hd

{rmatrix, rstart} = Solution.rotate_cw(matrix, start)
res = Solution.move(rmatrix, rstart)

res
|> Enum.map(fn line -> Enum.count(line, &(&1 == ?x)) end)
|> Enum.sum()
|> IO.inspect(label: "Total positions")
