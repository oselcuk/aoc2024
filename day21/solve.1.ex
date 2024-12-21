Mix.install([:memoize])

defmodule Solution do
  use Memoize

  def solve(code, depth) do
    cost =
      for(
        c <- String.to_charlist(code),
        reduce: [],
        do: (moves -> [{c, 1} | moves])
      )
      |> Enum.reverse()
      |> keypad_cost(depth)

    number = String.slice(code, 0, 3) |> String.to_integer()
    cost * number
  end

  defmemo keypad_cost(moves, 0) do
    Keyword.values(moves) |> Enum.sum()
  end

  defmemo keypad_cost(moves, depth) do
    moves =
      [{:A, 0} | moves]
      |> Enum.chunk_every(2, 1)

    for [{from, _}, {to, hits}] <- moves,
        moves_to = dists(from, to, hits),
        costs = Enum.map(moves_to, &keypad_cost(&1, depth - 1)),
        cost = Enum.min(costs),
        reduce: 0,
        do: (count -> count + cost)
  end

  defp dists(from, to, hits) do
    # Gap: 0, 0
    coords = %{
      ?0 => {0, 1},
      ?1 => {-1, 0},
      ?2 => {-1, 1},
      ?3 => {-1, 2},
      ?4 => {-2, 0},
      ?5 => {-2, 1},
      ?6 => {-2, 2},
      ?7 => {-3, 0},
      ?8 => {-3, 1},
      ?9 => {-3, 2},
      ?A => {0, 2},
      :A => {0, 2},
      :up => {0, 1},
      :left => {1, 0},
      :down => {1, 1},
      :right => {1, 2}
    }

    {x1, y1} = Map.get(coords, from)
    {x2, y2} = Map.get(coords, to)

    moves =
      [
        {:up, x1 - x2},
        {:down, x2 - x1},
        {:left, y1 - y2},
        {:right, y2 - y1}
      ]
      |> Enum.filter(fn {_, moves} -> moves > 0 end)

    cond do
      # Starting on gap row, must move up/down first
      x1 == 0 and y2 == 0 -> [Enum.reverse(moves)]
      # Starting on gap col, most move left/right first
      x2 == 0 and y1 == 0 -> [moves]
      # Otherwise both orders are allowed
      true -> [moves, Enum.reverse(moves)]
    end
    |> Enum.map(&([{:A, hits} | &1] |> Enum.reverse()))
  end
end

codes = IO.read(:eof) |> String.split("\n", trim: true)

codes
|> Stream.map(&Solution.solve(&1, 3))
|> Enum.sum()
|> IO.inspect(label: "Part 1")

codes
|> Stream.map(&Solution.solve(&1, 26))
|> Enum.sum()
|> IO.inspect(label: "Part 2")
