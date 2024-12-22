defmodule Solution do
  import Bitwise

  def iterate(a) do
    mask = 0x1000000 - 1
    a = bxor(a, a <<< 6) &&& mask
    a = bxor(a, a >>> 5) &&& mask
    a = bxor(a, a <<< 11) &&& mask
    a
  end
end

for input <- IO.stream(),
    secret = input |> String.trim() |> String.to_integer(),
    reduce: 0 do
  total ->
    final = for _ <- 1..2000, reduce: secret, do: (secret -> Solution.iterate(secret))
    # IO.inspect(final, label: "#{secret}")
    total + final
end
|> IO.inspect(label: "Part 1")
