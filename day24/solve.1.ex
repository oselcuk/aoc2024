defmodule Solution do
  def solve(ops, vals) do
    for(
      {var, op} <- ops,
      reduce: vals,
      do: (vals -> resolve(vals, ops, var, op) |> elem(1))
    )
    |> Stream.filter(fn {var, val} -> val and String.starts_with?(var, "z") end)
    |> Stream.map(fn {var, _} -> var |> String.slice(1, 2) |> String.to_integer() end)
    |> Enum.sum_by(&(2 ** &1))
  end

  defp resolve(vals, ops, var, op) do
    # IO.inspect({var, op}, label: "Resolve")

    if (res = Map.get(vals, var)) != nil do
      {res, vals}
    else
      {l, r, op} = op
      {l, vals} = resolve(vals, ops, l, Map.get(ops, l))
      {r, vals} = resolve(vals, ops, r, Map.get(ops, r))

      res =
        case op do
          "AND" -> l and r
          "OR" -> l or r
          "XOR" -> l != r
        end

      {res, Map.put(vals, var, res)}
    end
  end
end

[inputs, ops] =
  IO.read(:eof)
  |> String.split("\n\n")
  |> Enum.map(&String.split(&1, "\n", trim: true))

vals =
  for line <- inputs,
      [name, val] = String.split(line, ": "),
      into: %{},
      do: {name, val == "1"}

# IO.inspect(inputs, label: "Inputs")

ops =
  for line <- ops,
      [l, op, r, to] = String.split(line, ~r/ (-> )?/, trim: true),
      into: %{},
      do: {to, {l, r, op}}

Solution.solve(ops, vals) |> IO.inspect(label: "Part 1")
