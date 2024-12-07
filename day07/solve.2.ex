defmodule Solution do
  @spec solve(String.t()) :: integer()
  def solve(line) do
    [goal, head | numbers] =
      line |> String.trim() |> String.split(~r/:? /) |> Enum.map(&String.to_integer/1)

    if valid(goal, head, numbers), do: goal, else: 0
  end

  @spec valid(integer(), integer(), list(integer)) :: boolean()
  def valid(goal, result, []), do: goal == result

  def valid(goal, result, [head | rest]),
    do:
      valid(goal, result + head, rest) or valid(goal, result * head, rest) or
        valid(goal, concat_ints(result, head), rest)

  @spec concat_ints(integer(), integer()) :: integer()
  def concat_ints(l, r), do: (Integer.to_string(l) <> Integer.to_string(r)) |> String.to_integer()
end

IO.stream()
|> Stream.map(&Solution.solve/1)
|> Enum.sum()
|> IO.inspect()
