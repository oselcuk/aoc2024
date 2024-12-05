defmodule Solution do
  def valid([page | pages], cmp),
    do: Enum.all?(pages, &cmp.(page, &1)) and valid(pages, cmp)

  def valid([], _), do: true
end

[rules_input, manuals_input] = IO.read(:eof) |> String.split("\n\n", trim: true)

rules =
  for line <- String.split(rules_input, "\n", trim: true) do
    line
    |> String.split("|")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

cmp = fn a, b -> Enum.find(rules, &(&1 == {a, b})) != nil end

manuals =
  for line <- String.split(manuals_input, "\n", trim: true) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

{valid, invalid} = Enum.split_with(manuals, &Solution.valid(&1, cmp))

middle = fn list ->
  tupe = List.to_tuple(list)
  mid = div(tuple_size(tupe), 2)
  elem(tupe, mid)
end

valid |> Enum.map(middle) |> Enum.sum() |> IO.inspect()

for(
  manual <- invalid,
  do: Enum.sort(manual, cmp) |> middle.()
)
|> Enum.sum()
|> IO.inspect()
