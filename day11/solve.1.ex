defmodule Solution do
  @spec solve(list(integer())) :: integer()
  def solve(input) do
    for _ <- 1..25, reduce: input do
      input -> Enum.flat_map(input, &evolve/1)
    end
    |> Enum.count()
  end

  defp evolve(0), do: [1]

  defp evolve(number) do
    text = Integer.to_string(number)
    digits = String.length(text)

    if rem(digits, 2) == 0 do
      String.split_at(text, div(digits, 2))
      |> Tuple.to_list()
      |> Enum.map(&String.to_integer/1)
    else
      [number * 2024]
    end
  end
end

input =
  IO.read(:line)
  |> String.split([" ", "\n"], trim: true)
  |> Enum.map(&String.to_integer/1)

IO.inspect(Solution.solve(input))
