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
  for line <- IO.stream() |> Stream.take(1024),
      line = String.trim(line),
      line != "",
      [a, b] = String.split(line, ",") |> Enum.map(&String.to_integer/1),
      into: MapSet.new(),
      do: {a, b}

obstacles |> Solution.solve() |> IO.inspect()
