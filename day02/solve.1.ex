defmodule Solution do
  def pairwise(enumerable) do
    enumerable
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(&List.to_tuple/1)
  end

  def safe(nums, dampener \\ true) do
    diffs =
      nums
      |> pairwise()
      |> Enum.map(fn {l, r} -> l - r end)

    valid =
      Enum.all?(diffs, &(abs(&1) < 4)) and
        pairwise(diffs) |> Enum.all?(fn {l, r} -> l * r > 0 end)

    if not valid and dampener do
      0..(length(nums) - 1)
      |> Stream.map(&List.delete_at(nums, &1))
      |> Stream.map(&safe(&1, false))
      |> Enum.any?()
    else
      valid
    end
  end
end

nums =
  IO.stream()
  |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)

nums
|> Stream.map(&Solution.safe(&1, false))
|> Enum.count(& &1)
|> IO.inspect()

nums
|> Stream.map(&Solution.safe/1)
|> Enum.count(& &1)
|> IO.inspect()
