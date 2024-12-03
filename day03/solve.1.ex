pattern = ~r/mul\((\d{1,3}),(\d{1,3})\)/

process_line = fn line ->
  Regex.scan(pattern, line, capture: :all_but_first)
  |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) |> List.to_tuple() end)
  |> Enum.reduce(0, fn {l, r}, acc -> acc + l * r end)
end

IO.stream()
|> Enum.map(process_line)
|> Enum.sum()
|> IO.inspect()
