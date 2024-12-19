Mix.install([:memoize])

defmodule Solution do
  use Memoize

  def solve(_, ""), do: 1

  defmemo solve(words, pattern) do
    patternLen = String.length(pattern)

    for word <- words,
        String.starts_with?(pattern, word),
        reduce: 0,
        do: (acc -> acc + solve(words, String.slice(pattern, String.length(word), patternLen)))
  end
end

[words, patterns] =
  IO.read(:eof)
  |> String.split("\n\n")

words = String.split(words, ", ")
patterns = String.split(patterns, "\n", trim: true)

{count, sum} =
  for pattern <- patterns, reduce: {0, 0} do
    {count, sum} ->
      res = Solution.solve(words, pattern)
      {count + if(res > 0, do: 1, else: 0), sum + res}
  end

IO.inspect(count, label: "Part 1")
IO.inspect(sum, label: "Part 2")
