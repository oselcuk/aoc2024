defmodule Solution do
  @spec solve(String.t()) :: integer()
  def solve(input) do
    blocks =
      input
      |> Enum.with_index()
      |> Enum.map(fn {len, idx} ->
        List.duplicate(if(rem(idx, 2) == 0, do: div(idx, 2), else: -1), len)
      end)
      |> List.flatten()

    solve_(blocks, 0)
  end

  defp solve_([], _), do: 0

  defp solve_([-1 | rest], idx) do
    case rest |> Enum.reverse() |> Enum.drop_while(&(&1 < 0)) do
      [] -> 0
      [val | reversed] -> val * idx + solve_(Enum.reverse(reversed), idx + 1)
    end
  end

  defp solve_([val | rest], idx), do: idx * val + solve_(rest, idx + 1)
end

input = IO.read(:line) |> String.trim() |> String.to_charlist() |> Enum.map(&(&1 - ?0))

IO.inspect(Solution.solve(input))
# IO.inspect(Solution.solve_2(input))
