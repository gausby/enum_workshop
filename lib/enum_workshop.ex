defmodule EnumWorkshop do
  @doc """
  reimplement the functionality of `Enum.count/1` without using the
  `count/1` function from the `Enum.module`.

    iex> EnumWorkshop.count([])
    0

    iex> EnumWorkshop.count([1])
    1

    iex> EnumWorkshop.count([1, 2, 3, 4])
    4
  """
  @spec count(list) :: [Any]
  def count(list) do
    do_count(list, 0)
  end

  defp do_count([], acc),
    do: acc
  defp do_count([_head|rest], acc),
    do: do_count(rest, acc + 1)

  @doc """
  reimplement the functionality of `Enum.member?/1` without using the
  `member?/1` function from the `Enum.module`.

    iex> EnumWorkshop.member?([], 5)
    false

    iex> EnumWorkshop.member?([1], 1)
    true

    iex> EnumWorkshop.member?([1, 2, 3, 4], 3)
    true

    iex> EnumWorkshop.member?([1, 2, 3, 4, 7], 7)
    true

    iex> EnumWorkshop.member?([8, 2, 3, 4, 7], 8)
    true

    iex> EnumWorkshop.member?([1, 2, 3, 4], 7)
    false
  """
  @spec member?(list, Any) :: Boolean
  def member?([n|_], n) do
    true
  end
  def member?([], _) do
    false
  end
  def member?([_|tail], n) do
    member?(tail, n)
  end

  @doc """
  reimplement the functionality of `Enum.reverse/1` without using the
  `reverse/1` function from the `Enum.module`.

    iex> EnumWorkshop.reverse([1, 2, 3, 4])
    [4, 3, 2, 1]

    iex> EnumWorkshop.reverse([1, 1, 2, 2])
    [2, 2, 1, 1]

    iex> EnumWorkshop.reverse([1, 2, 1])
    [1, 2, 1]
  """
  @spec reverse(list) :: [Any]
  def reverse(list) do
    do_reverse(list, [])
  end

  defp do_reverse([], acc) do
    acc
  end
  defp do_reverse([head|tail], acc) do
    do_reverse(tail, [head|acc])
  end

  @doc """
  reimplement the functionality of `Enum.min/1` without using the
  `min/1` function from the `Enum.module`.

    iex> EnumWorkshop.min([])
    :error

    iex> EnumWorkshop.min([1, 2, 3, 4])
    1

    iex> EnumWorkshop.min([4, 3, 2, 1])
    1

    iex> EnumWorkshop.min([5, 42, 3, 108, 3])
    3
  """
  @spec min([Integer]) :: Integer | :error
  def min([]) do
    :error
  end
  def min([head|tail]) do
    do_min(tail, head)
  end

  def do_min([], min) do
    min
  end
  def do_min([head|tail], min) when head < min do
    do_min(tail, head)
  end
  def do_min([_|tail], min) do
    do_min(tail, min)
  end

  @doc """
  reimplement the functionality of `Enum.filter/2` without using the
  `filter/2` function from the `Enum.module`.

    iex> EnumWorkshop.filter([1, 2, 3, 4], fn x -> x < 3 end)
    [1, 2]

    iex> EnumWorkshop.filter([1, 1, 2, 2], fn x -> x == 1 end)
    [1, 1]

    iex> EnumWorkshop.filter([1, 2, 3, 4, 5, 6], fn x -> rem(x, 2) == 1 end)
    [1, 3, 5]
  """
  @spec filter(list, function) :: [Any]
  def filter(list, fun) do
    do_filter list, fun, []
  end

  defp do_filter([], _, acc) do
    reverse acc
  end
  defp do_filter([head|tail], fun, acc) do
    if fun.(head) do
      do_filter(tail, fun, [head|acc])
    else
      do_filter(tail, fun, acc)
    end
  end

  @doc """
  reimplement the functionality of `Enum.dedup/1` without using the
  `dedup/1` function from the `Enum.module`.

    iex> EnumWorkshop.dedup([])
    []

    iex> EnumWorkshop.dedup([1, 2, 3, 4])
    [1, 2, 3, 4]

    iex> EnumWorkshop.dedup([1, 1, 2, 2])
    [1, 2]

    iex> EnumWorkshop.dedup([1, 1, 2, 2, 1, 1])
    [1, 2, 1]
  """
  @spec dedup(list) :: [Any]
  def dedup([]),
    do: []
  def dedup([head|tail]),
    do: do_dedup(tail, head, [head])

  defp do_dedup([], _, acc),
    do: reverse acc
  defp do_dedup([topic|tail], topic, acc),
    do: do_dedup(tail, topic, acc)
  defp do_dedup([head|tail], _, acc),
    do: do_dedup(tail, head, [head|acc])

  @doc """
  reimplement the functionality of `Enum.chunk/2` without using the
  `chunk/1` function from the `Enum.module`.

    iex> EnumWorkshop.chunk([1, 2, 3, 4], 5)
    []

    iex> EnumWorkshop.chunk([1, 2, 3, 4], 2)
    [[1, 2], [3, 4]]

    iex> EnumWorkshop.chunk([4, 3, 2, 1], 2)
    [[4, 3], [2, 1]]

    iex> EnumWorkshop.chunk([5, 42, 3, 108], 3)
    [[5, 42, 3]]
  """
  @spec chunk(Any, pos_integer) :: [list]
  def chunk(list, n),
    do: do_chunk(list, n, [])

  defp do_chunk([], _, acc),
    do: reverse(acc)
  defp do_chunk(list, n, acc) do
    case take(list, n) do
      {taken, rest} when length(taken) == n ->
        do_chunk(rest, n, [taken|acc])
      {_, rest} ->
        do_chunk(rest, n, acc)
    end
  end

  @doc """
  Take the first n-elements of a list, return a two tuple containing
  the list of taken elements and the remaining elements in the list.

    iex> EnumWorkshop.take([1, 2, 3], 1)
    {[1], [2, 3]}

    iex> EnumWorkshop.take([1, 2, 3], 2)
    {[1, 2], [3]}

    iex> EnumWorkshop.take([1, 2, 3], 3)
    {[1, 2, 3], []}

    iex> EnumWorkshop.take([1, 2, 3], 0)
    {[], [1, 2, 3]}

    iex> EnumWorkshop.take([1, 2, 3], 4)
    {[1, 2, 3], []}

    iex> EnumWorkshop.take([], 4)
    {[], []}
  """
  @spec take([Any], pos_integer) :: {[Any], [Any]}
  def take(list, n),
    do: do_take(list, n, [])

  defp do_take([head|tail], n, acc) when n > 0,
    do: do_take(tail, n - 1, [head|acc])
  defp do_take(rest, _, acc),
    do: {reverse(acc), rest}
end
