Mix.install([:prioqueue])

defmodule Solution do
  def solve(matrix, start) do
    pq = Prioqueue.empty() |> Prioqueue.insert({0, {start, {0, 1}}, nil})
    paths = Map.new()

    Stream.unfold({pq, paths}, &pop(matrix, &1)) |> Stream.take(-1) |> Enum.to_list() |> hd()
  end

  defp pop(matrix, {pq, paths}) do
    # IO.inspect(pq)
    # IO.inspect(paths)
    {{cost, coords, from}, pq} = Prioqueue.extract_min!(pq)
    tile = access(matrix, coords)

    cond do
      tile == ?E ->
        IO.inspect(cost, label: "Cost")
        # IO.inspect(paths, label: "Paths")
        seats = find_seats(paths, from) |> MapSet.size()
        IO.inspect(seats + 1, label: "Seats")

        nil

      seen = Map.get(paths, coords) ->
        {prevs, pdist} = seen

        if pdist == cost do
          {cost, {pq, Map.put(paths, coords, {[from | prevs], pdist})}}
        else
          {cost, {pq, paths}}
        end

      tile == ?. || tile == ?S ->
        [forward, t1, t2] = moves(coords)

        pq =
          pq
          |> Prioqueue.insert({cost + 1, forward, coords})
          |> Prioqueue.insert({cost + 1001, t1, coords})
          |> Prioqueue.insert({cost + 1001, t2, coords})

        paths = Map.put(paths, coords, {[from], cost})
        {cost, {pq, paths}}

      true ->
        {cost, {pq, paths}}
    end
  end

  defp find_seats(paths, coords) do
    # IO.inspect(coords)
    {loc, _} = coords
    locs = MapSet.new([loc])

    case Map.get(paths, coords) do
      {[nil], _} ->
        locs

      {from, _} ->
        Enum.map(from, &find_seats(paths, &1))
        |> Enum.reduce(&MapSet.union/2)
        |> MapSet.union(locs)
    end
  end

  defp add({x, y}, {dx, dy}), do: {x + dx, y + dy}

  defp moves({coord, dir}) do
    {cw, ccw} =
      case dir do
        {0, _} -> {{-1, 0}, {1, 0}}
        _ -> {{0, -1}, {0, 1}}
      end

    [
      {add(coord, dir), dir},
      {add(coord, cw), cw},
      {add(coord, ccw), ccw}
    ]
  end

  defp access(matrix, {{x, y}, _}) do
    matrix |> elem(x) |> elem(y)
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)
  |> Stream.map(&(String.to_charlist(&1) |> List.to_tuple()))
  |> Enum.to_list()
  |> List.to_tuple()

# |> IO.inspect()

start =
  for(
    {row, i} <- Enum.with_index(Tuple.to_list(input)),
    {c, j} <- Enum.with_index(Tuple.to_list(row)),
    c == ?S,
    do: {i, j}
  )
  |> Enum.take(1)
  |> hd()

Solution.solve(input, start)
