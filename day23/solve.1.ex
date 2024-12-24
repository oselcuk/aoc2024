defmodule Solution do
  def solve(map) do
    for {a, nodes} <- map,
        b <- nodes,
        c <- Map.get(map, b, []),
        Map.get(map, c, []) |> MapSet.member?(a),
        Enum.any?([a, b, c], &String.starts_with?(&1, "t")),
        reduce: 0,
        do: (count -> count + 1)
  end
end

map =
  for input <- IO.stream(),
      [l, r] = input |> String.trim() |> String.split("-"),
      reduce: %{},
      do: (map ->
             map
             |> Map.update(l, MapSet.new([r]), &MapSet.put(&1, r))
             |> Map.update(r, MapSet.new([l]), &MapSet.put(&1, l)))

map
|> Solution.solve()
|> div(6)
|> IO.inspect(label: "Part 1")
