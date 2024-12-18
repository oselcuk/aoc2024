# Mix.install([:prioqueue])

defmodule Solution do
  def neighbors({x, y}), do: [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]

  def solve(obstacles, target \\ {70, 70}, queue \\ [{{0, 0}, 0}])
  def solve(_, _, []), do: nil

  def solve(obstacles, target, [{{x, y}, dist} | queue]) do
    {tx, ty} = target
    marked = MapSet.put(obstacles, {x, y})

    cond do
      {x, y} == target ->
        dist

      x < 0 || y < 0 || x > tx || y > ty || MapSet.member?(obstacles, {x, y}) ->
        solve(marked, target, queue)

      true ->
        add = for(loc <- neighbors({x, y}), do: {loc, dist + 1})
        solve(marked, target, Enum.concat(queue, add))
    end
  end
end

obstacles =
  for line <- IO.stream(),
      line = String.trim(line),
      line != "",
      [a, b] = String.split(line, ",") |> Enum.map(&String.to_integer/1),
      do: {a, b}

{initial, [first | rest]} = Enum.split(obstacles, 1024)
obstacles = MapSet.new(initial)

obstacles |> Solution.solve() |> IO.inspect(label: "Part 1")

Stream.scan(rest, {first, obstacles}, fn obstacle, {_, obstacles} ->
  obstacles = MapSet.put(obstacles, obstacle)

  if Solution.solve(obstacles) == nil do
    {obstacle, obstacles}
  else
    {nil, obstacles}
  end
end)
|> Stream.drop_while(&(elem(&1, 0) == nil))
|> Stream.take(1)
|> Enum.to_list()
|> hd()
|> elem(0)
|> IO.inspect("Part 2")
