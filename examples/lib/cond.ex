defmodule Cond do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro fmi_unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end

defmodule TestUnless do
  use Cond

  def test do
    fmi_unless File.exists?("test.txt") do
      File.write("test.txt", DateTime.utc_now |> DateTime.to_string)
    end
  end
end
