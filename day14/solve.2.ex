defmodule Solution do
  @spec solve(list(String.t()), integer()) :: integer()
  def solve(input, iterations) do
    [first | input] = input
    [mx, my] = first |> String.split(",") |> Enum.map(&String.to_integer/1)

    robots =
      for line <- input do
        Regex.run(~r/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/, line, capture: :all_but_first)
        |> Enum.map(&String.to_integer/1)
      end

    len = length(robots)

    for i <- 0..iterations do
      locations =
        for [x, y, dx, dy] <- robots do
          x = Integer.mod(x + i * dx, mx)
          y = Integer.mod(y + i * dy, my)
          {x, y}
        end

      {midx, midy} = for {x, y} <- locations, reduce: {0, 0}, do: ({tx, ty} -> {tx + x, ty + y})
      midx = midx / len
      midy = midy / len

      dist =
        for {x, y} <- locations,
            {dx, dy} = {x - midx, y - midy},
            reduce: 0,
            do: (dist -> dist + dx * dx + dy * dy)

      if dist < 400_000, do: visualize(locations, {mx, my})
      dist
    end
  end

  defp visualize(robots, {mx, my}) do
    coords = MapSet.new(robots)

    for y <- 0..my do
      for x <- 0..mx do
        IO.write(if MapSet.member?(coords, {x, y}), do: "X", else: " ")
      end

      IO.write("\n")
    end
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)

Solution.solve(input, 10_000)
|> Enum.with_index()
|> Enum.sort_by(&elem(&1, 0))
|> Enum.take(100)
|> Enum.map(fn {dist, iterations} -> IO.puts("#{iterations}\t#{dist}") end)
