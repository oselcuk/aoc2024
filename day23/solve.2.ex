Mix.install([:memoize])

defmodule Solution do
  use Memoize

  def solve(map) do
    map
    |> Map.keys()
    |> Stream.map(&max_component(map, MapSet.new([&1])))
    |> Enum.max_by(&MapSet.size/1)
  end

  def max_component(map, nodes) do
    # Use only `nodes` as the cache key, since `map` doesn't change
    Memoize.Cache.get_or_run(
      {__MODULE__, :resolve, [nodes]},
      fn ->
        nodes
        |> Stream.map(&Map.get(map, &1))
        |> Enum.reduce(&MapSet.intersection/2)
        |> MapSet.difference(nodes)
        |> Stream.map(&max_component(map, MapSet.put(nodes, &1)))
        |> Stream.concat([nodes])
        |> Enum.max_by(&MapSet.size/1)
      end
    )
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
|> Enum.sort()
|> Enum.join(",")
|> IO.inspect(label: "Part 2")
