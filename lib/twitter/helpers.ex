defmodule Helpers do
  @doc "Destructure {:ok, data} tuples. Useful for pipe sequences."
  def unwrap({:ok, data}), do: data
end
