defmodule Solution do
  def next_coord({x, y}, move) do
    case move do
      ?^ -> {x - 1, y}
      ?> -> {x, y + 1}
      ?v -> {x + 1, y}
      ?< -> {x, y - 1}
    end
  end

  defp push(matrix, coord, move, prev \\ ?.)
  defp push(nil, _, _, _), do: nil

  defp push(matrix, {x, y}, move, prev) do
    {nx, ny} = next_coord({x, y}, move)
    val = get(matrix, {x, y})

    updated =
      case val do
        ?# ->
          nil

        ?. ->
          matrix

        # Don't split when moving horizontally
        _ when move == ?< or move == ?> ->
          push(matrix, {nx, ny}, move, val)

        ?@ ->
          push(matrix, {nx, ny}, move, val)

        ?[ ->
          push(matrix, {nx, ny}, move, ?[)
          |> push({nx, ny + 1}, move, ?])
          |> set({x, y + 1}, ?.)

        ?] ->
          push(matrix, {nx, ny - 1}, move, ?[)
          |> push({nx, ny}, move, ?])
          |> set({x, y - 1}, ?.)
      end
      |> set({x, y}, prev)

    case {updated, val} do
      {nil, ?@} -> {matrix, {x, y}}
      {_, ?@} -> {updated, {nx, ny}}
      _ -> updated
    end
  end

  def solve(matrix, moves) do
    x = tuple_size(matrix) - 1
    y = tuple_size(elem(matrix, 0)) - 1
    robot = for(i <- 0..x, j <- 0..y, get(matrix, {i, j}) == ?@, do: {i, j}) |> hd()

    {matrix, _} =
      for move <- String.to_charlist(moves),
          reduce: {matrix, robot},
          do: ({matrix, coord} -> push(matrix, coord, move))

    for i <- 0..x,
        j <- 0..y,
        get(matrix, {i, j}) == ?[,
        reduce: 0,
        do: (acc -> acc + 100 * i + j)
  end

  defp get(nil, _), do: nil
  defp get(matrix, {x, y}), do: matrix |> elem(x) |> elem(y)

  defp set(nil, _, _), do: nil

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
  |> Enum.map(fn s ->
    String.replace(s, ~r/./, fn c ->
      case c do
        "." -> ".."
        "#" -> "##"
        "@" -> "@."
        "O" -> "[]"
      end
    end)
  end)
  |> Enum.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> List.to_tuple()

IO.inspect(Solution.solve(matrix, moves))
