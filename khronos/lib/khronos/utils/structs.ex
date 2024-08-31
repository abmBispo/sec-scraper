defmodule Khronos.Utils.Structs do
  def to_map(%{__struct__: struct} = term) when struct in [NaiveDateTime, DateTime],
    do: term

  def to_map(%{__struct__: _} = struct) do
    struct
    |> Map.from_struct()
    |> Enum.map(fn {k, v} -> {k, to_map(v)} end)
    |> Map.new()
  end

  def to_map(list) when is_list(list) do
    Enum.map(list, &to_map/1)
  end

  def to_map(term), do: term
end
