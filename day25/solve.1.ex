{locks, keys} =
  for(
    input <- IO.read(:eof) |> String.split("\n\n", trim: true),
    is_key <- [String.starts_with?(input, "#")],
    lines = String.split(input, "\n", trim: true) |> Enum.map(&String.to_charlist/1),
    schematic = lines |> Enum.zip() |> Enum.map(&Tuple.to_list/1),
    counts = Enum.map(schematic, fn line -> Enum.count(line, &(&1 == ?#)) end),
    reduce: {[], []},
    do: ({locks, keys} -> if is_key, do: {locks, [counts | keys]}, else: {[counts | locks], keys})
  )

for(
  lock <- locks,
  key <- keys,
  pairs = Enum.zip(lock, key),
  Enum.map(pairs, fn {l, k} -> l + k end) |> Enum.all?(&(&1 <= 7)),
  reduce: 0,
  do: (acc -> acc + 1)
)
|> IO.inspect(label: "Part 1")
