defmodule Solution do
  @spec solve(list(integer())) :: integer()
  def solve(input) do
    {result, _} =
      for number <- input, reduce: {0, Map.new()} do
        {sum, memo} ->
          {score, memo} = evolve(number, 75, memo)
          {sum + score, memo}
      end

    result
  end

  defp evolve(_, 0, memo), do: {1, memo}
  defp evolve(0, n, memo), do: evolve(1, n - 1, memo)

  defp evolve(number, n, memo) do
    if res = Map.get(memo, {number, n}) do
      {res, memo}
    else
      digits = floor(:math.log10(number))

      {res, memo} =
        if rem(digits, 2) != 0 do
          split = round(:math.pow(10, (digits + 1) / 2))
          l = div(number, split)
          r = rem(number, split)

          {l_score, memo} = evolve(l, n - 1, memo)
          {r_score, memo} = evolve(r, n - 1, memo)
          {l_score + r_score, memo}
        else
          evolve(number * 2024, n - 1, memo)
        end

      {res, Map.put(memo, {number, n}, res)}
    end
  end
end

input =
  IO.read(:line)
  |> String.split([" ", "\n"], trim: true)
  |> Enum.map(&String.to_integer/1)

IO.inspect(Solution.solve(input))
