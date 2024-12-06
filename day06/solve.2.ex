defmodule Solution do
  def move({x, y}, dir) do
    case dir do
      :up -> {x - 1, y}
      :down -> {x + 1, y}
      :left -> {x, y - 1}
      :right -> {x, y + 1}
    end
  end

  def turn(dir) do
    case dir do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  def access(matrix, {x, y}) do
    dim = tuple_size(matrix)

    if x >= 0 and x < dim and y >= 0 and y < dim do
      elem(elem(matrix, x), y)
    else
      nil
    end
  end

  def solve(matrix, coord, dir \\ :up, moves \\ MapSet.new()) do
    key = {coord, dir}

    if MapSet.member?(moves, key) do
      :loop
    else
      moves = MapSet.put(moves, key)
      next = move(coord, dir)

      case access(matrix, next) do
        # Out of bounds, finished
        nil -> moves
        # Obstacle, turn
        ?# -> solve(matrix, coord, turn(dir), moves)
        # No obstacle, continue
        _ -> solve(matrix, next, dir, moves)
      end
    end
  end
end

matrix =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> List.to_tuple()

dim = tuple_size(matrix)

start =
  for(i <- 0..(dim - 1), j <- 0..(dim - 1), elem(elem(matrix, i), j) == ?^, do: {i, j}) |> hd()

moves = Solution.solve(matrix, start)

visited_tiles =
  Stream.map(moves, fn {coord, _} -> coord end)
  |> Stream.uniq()

# Part 1
visited_tiles
|> Enum.count()
|> IO.inspect(label: "Total moves")

# Part 2: Try replacing every visited tile with an obstacle, count loops
for(
  {x, y} <- visited_tiles,
  {x, y} != start,
  updated = put_elem(matrix, x, put_elem(elem(matrix, x), y, ?#)),
  Solution.solve(updated, start) == :loop,
  do: 1
)
|> Enum.count()
|> IO.inspect(label: "Loops")
