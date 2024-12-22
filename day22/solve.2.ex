defmodule Solution do
  import Bitwise

  def iterate(a) do
    mask = 0x1000000 - 1
    a = bxor(a, a <<< 6) &&& mask
    a = bxor(a, a >>> 5) &&& mask
    a = bxor(a, a <<< 11) &&& mask
    a
  end

  def changes(secret) do
    Stream.iterate(secret, &iterate/1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [l, r] -> {rem(r, 10) - rem(l, 10), rem(r, 10)} end)
    |> Stream.take(2000)
  end

  def gains(difs) do
    for chunk <- Stream.chunk_every(difs, 4, 1, :discard),
        reduce: %{} do
      scores ->
        pattern = chunk |> Enum.map(&elem(&1, 0)) |> List.to_tuple()
        score = List.last(chunk) |> elem(1)
        Map.put_new(scores, pattern, score)
    end
  end
end

IO.stream()
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.map(&Solution.changes/1)
|> Stream.map(&Solution.gains/1)
|> Enum.reduce(&Map.merge(&1, &2, fn _, val1, val2 -> val1 + val2 end))
|> Map.values()
|> Enum.max()
|> IO.inspect(label: "Part 2")
