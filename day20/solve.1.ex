defmodule Solution do
  def solve(matrix) do
    finish = find(matrix, ?E)
    dists = Map.new()
    dists = dist(matrix, finish, dists, 0)

    cheat(dists, 2, 100)
    |> IO.inspect(label: "Part 1")

    cheat(dists, 20, 100)
    |> IO.inspect(label: "Part 2")
  end

  defp cheat(dists, max_cheat, min_saved) do
    for(
      {from, dist1} <- dists,
      cheat <- 2..max_cheat,
      dx_abs <- 0..cheat,
      dy_abs = cheat - dx_abs,
      dx <- [dx_abs, -dx_abs],
      dy <- [dy_abs, -dy_abs],
      to = add(from, {dx, dy}),
      dist2 = Map.get(dists, to),
      saved = dist1 - dist2 - cheat,
      saved >= min_saved,
      reduce: Map.new(),
      do: (cheats -> Map.put(cheats, {from, to}, saved))
    )
    |> Map.values()
    |> Enum.count()
  end

  defp dist(matrix, coords, dists, so_far) do
    dists = Map.put(dists, coords, so_far)

    for d <- [{0, 1}, {1, 0}, {0, -1}, {-1, 0}],
        target = add(coords, d),
        get(matrix, target) != ?#,
        !Map.has_key?(dists, target),
        reduce: dists,
        do: (dists -> dist(matrix, target, dists, so_far + 1))
  end

  defp add({x, y}, {dx, dy}), do: {x + dx, y + dy}

  defp get(matrix, {x, y}), do: matrix |> elem(x) |> elem(y)

  defp find(matrix, val) do
    for(
      {row, x} <- Enum.with_index(Tuple.to_list(matrix)),
      {c, y} <- Enum.with_index(Tuple.to_list(row)),
      c == val,
      do: {x, y}
    )
    |> Enum.take(1)
    |> hd()
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Stream.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> Enum.to_list()
  |> List.to_tuple()

Solution.solve(input)
