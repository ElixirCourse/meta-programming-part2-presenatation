defmodule Cond do
  defmacro __using__(_options) do
    quote do
      import Kernel, except: [unless: 2]
      import unquote(__MODULE__), only: [unless: 2]
    end
  end

  defmacro unless(expr, do: block) do
    quote do
      IO.inspect(unquote(expr))
      if !unquote(expr), do: unquote(block)
    end
  end
end

defmodule TestUnless do
  use Cond

  def test do
    unless File.exists?("test.txt") do
      File.write("test.txt", DateTime.utc_now |> DateTime.to_string)
    end
  end
end
