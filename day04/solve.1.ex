count_xmas = fn lines ->
  lines
  |> Enum.map(&to_string/1)
  |> Enum.map(&((Regex.scan(~r/XMAS/, &1) |> length()) + (Regex.scan(~r/SAMX/, &1) |> length())))
  |> Enum.sum()
end

transpose = fn matrix ->
  Enum.zip(matrix)
  |> Enum.map(&Tuple.to_list(&1))
end

rows =
  IO.stream()
  |> Stream.map(&String.trim/1)
  |> Enum.map(&to_charlist/1)

columns = transpose.(rows)

height = length(rows)

diag_r =
  for {row, i} <- Enum.with_index(rows) do
    List.duplicate(?., i) ++ row ++ List.duplicate(?., height - i - 1)
  end
  |> transpose.()

diag_c =
  for {row, i} <- Enum.with_index(rows) do
    List.duplicate(?., height - i - 1) ++ row ++ List.duplicate(?., i)
  end
  |> transpose.()

# Part 1
[rows, columns, diag_c, diag_r]
|> Enum.map(count_xmas)
|> Enum.sum()
|> IO.inspect()

# Part 2
tupes =
  rows
  |> Enum.map(&List.to_tuple/1)
  |> List.to_tuple()

get = fn i, j -> tupes |> elem(i) |> elem(j) end

mas = MapSet.new([?M, ?S])

for {row, i} <- Enum.with_index(rows) |> Enum.drop(1) |> Enum.drop(-1),
    {c, j} <- Enum.with_index(row) |> Enum.drop(1) |> Enum.drop(-1),
    c == ?A,
    MapSet.new([get.(i - 1, j - 1), get.(i + 1, j + 1)]) == mas,
    MapSet.new([get.(i - 1, j + 1), get.(i + 1, j - 1)]) == mas do
  1
end
|> Enum.sum()
|> IO.inspect()
