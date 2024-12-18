defmodule Solution do
  import Bitwise

  def run({dat, registers, ip}) do
    args = {dat, registers, ip}

    if tuple_size(dat) <= ip do
      nil
    else
      case elem(dat, ip) do
        0 -> adv(args) |> run()
        1 -> bxl(args) |> run()
        2 -> bst(args) |> run()
        3 -> jnz(args) |> run()
        4 -> bxc(args) |> run()
        5 -> out(args) |> run()
        6 -> bdv(args) |> run()
        7 -> cdv(args) |> run()
      end
    end
  end

  defp adv({dat, {a, b, c}, ip}) do
    val = combo(dat, {a, b, c}, ip + 1)
    {dat, {a >>> val, b, c}, ip + 2}
  end

  defp bxl({dat, {a, b, c}, ip}) do
    val = elem(dat, ip + 1)
    {dat, {a, bxor(b, val), c}, ip + 2}
  end

  defp bst({dat, {a, b, c}, ip}) do
    val = combo(dat, {a, b, c}, ip + 1)
    {dat, {a, val &&& 7, c}, ip + 2}
  end

  defp jnz({dat, {a, b, c}, ip}) do
    val = elem(dat, ip + 1)
    ip = if a == 0, do: ip + 2, else: val
    {dat, {a, b, c}, ip}
  end

  defp bxc({dat, {a, b, c}, ip}) do
    {dat, {a, bxor(b, c), c}, ip + 2}
  end

  defp out({dat, {a, b, c}, ip}) do
    val = combo(dat, {a, b, c}, ip + 1)
    IO.write("#{val &&& 7},")
    {dat, {a, b, c}, ip + 2}
  end

  defp bdv({dat, {a, b, c}, ip}) do
    val = combo(dat, {a, b, c}, ip + 1)
    {dat, {a, a >>> val, c}, ip + 2}
  end

  defp cdv({dat, {a, b, c}, ip}) do
    val = combo(dat, {a, b, c}, ip + 1)
    {dat, {a, b, a >>> val}, ip + 2}
  end

  defp combo(dat, {a, b, c}, ip) do
    case elem(dat, ip) do
      4 -> a
      5 -> b
      6 -> c
      v -> v
    end
  end
end

[registers, program] = IO.read(:eof) |> String.split("\n\n")

registers =
  Regex.scan(~r/\d+/, registers)
  |> Enum.map(&List.first/1)
  |> Enum.map(&String.to_integer/1)
  |> List.to_tuple()

program =
  String.split(program, " ")
  |> List.last()
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
  |> List.to_tuple()

Solution.run({program, registers, 0})
IO.puts("")
