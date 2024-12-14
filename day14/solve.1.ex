defmodule Solution do
  @spec solve(list(String.t())) :: integer()
  def solve(input) do
    [first | input] = input
    [mx, my] = first |> String.split(",") |> Enum.map(&String.to_integer/1)

    midx = div(mx, 2)
    midy = div(my, 2)

    robots =
      for line <- input do
        [x, y, dx, dy] =
          Regex.run(~r/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/, line, capture: :all_but_first)
          |> Enum.map(&String.to_integer/1)

        x = Integer.mod(x + 100 * dx, mx)
        y = Integer.mod(y + 100 * dy, my)
        {x, y}
      end

    for {x, y} <- robots, x != midx, y != midy, reduce: [0, 0, 0, 0] do
      quads ->
        List.update_at(
          quads,
          if(x < midx, do: 0, else: 2) + if(y < midy, do: 0, else: 1),
          &(&1 + 1)
        )
    end
    |> Enum.product()
  end
end

input =
  IO.read(:eof)
  |> String.split("\n", trim: true)

IO.inspect(Solution.solve(input))
