defmodule Solution do
  def next_coord({x, y}, move) do
    case move do
      ?^ -> {x - 1, y}
      ?> -> {x, y + 1}
      ?v -> {x + 1, y}
      ?< -> {x, y - 1}
    end
  end

  defp find_space(matrix, coord, move) do
    case get(matrix, coord) do
      ?# -> nil
      ?. -> coord
      _ -> find_space(matrix, next_coord(coord, move), move)
    end
  end

  def move_robot(matrix, coord, move) do
    next = next_coord(coord, move)

    case find_space(matrix, next, move) do
      nil ->
        {matrix, coord}

      space ->
        {matrix
         |> set(space, ?O)
         |> set(next, ?@)
         |> set(coord, ?.), next}
    end
  end

  def solve(matrix, moves) do
    dim = tuple_size(matrix) - 1
    robot = for(i <- 0..dim, j <- 0..dim, get(matrix, {i, j}) == ?@, do: {i, j}) |> hd()

    {matrix, _} =
      for move <- String.to_charlist(moves),
          reduce: {matrix, robot},
          do: ({matrix, coord} -> move_robot(matrix, coord, move))

    for i <- 0..dim,
        j <- 0..dim,
        get(matrix, {i, j}) == ?O,
        reduce: 0,
        do: (acc -> acc + 100 * i + j)
  end

  defp get(matrix, {x, y}), do: matrix |> elem(x) |> elem(y)

  defp set(matrix, {x, y}, val) do
    row = elem(matrix, x)
    put_elem(matrix, x, put_elem(row, y, val))
  end
end

[matrix, moves] =
  IO.read(:eof)
  |> String.split("\n\n", trim: true)

moves = String.replace(moves, ~r/\s/, "")

matrix =
  matrix
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> List.to_tuple()

IO.inspect(Solution.solve(matrix, moves))
