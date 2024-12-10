defmodule Solution do
  @spec solve(String.t()) :: integer()
  def solve(input) do
    blocks =
      input
      |> Enum.with_index()
      |> Enum.map(fn {len, idx} ->
        if(rem(idx, 2) == 0, do: {:file, len, div(idx, 2)}, else: {:blank, len, 0})
      end)
      |> Enum.reverse()

    result = solve_(blocks) |> Enum.reverse()

    {score, _} =
      for block <- result, reduce: {0, 0} do
        {score, pos} ->
          {chk, next} = checksum(block, pos)
          {score + chk, next}
      end

    score
  end

  defp _pretty_print(blocks) do
    for {type, len, idx} <- blocks, c = if(type == :file, do: idx, else: "."), _ <- 1..len//1 do
      IO.write(c)
    end

    IO.write("\n")
  end

  defp checksum({:blank, len, _}, pos), do: {0, pos + len}
  defp checksum({:file, len, idx}, pos), do: {div((pos * 2 + len - 1) * len * idx, 2), pos + len}

  defp solve_([{:file, len, idx} | rest]) do
    # _pretty_print(Enum.reverse(rest))

    {prefix, insert} =
      rest
      |> Enum.reverse()
      |> Enum.split_while(fn {type, blank_len, _} -> type == :file or blank_len < len end)

    case {prefix, insert} do
      {prefix, []} ->
        [{:file, len, idx} | solve_(rest)]

      {prefix, [{:blank, blank_len, _} | rest]} ->
        (prefix ++ [{:file, len, idx}, {:blank, blank_len - len, 0}] ++ rest ++ [{:blank, len, 0}])
        |> Enum.reverse()
        |> solve_()
    end
  end

  defp solve_([blank | rest]), do: [blank | solve_(rest)]
  defp solve_([]), do: []
end

input = IO.read(:line) |> String.trim() |> String.to_charlist() |> Enum.map(&(&1 - ?0))
IO.inspect(Solution.solve(input))
