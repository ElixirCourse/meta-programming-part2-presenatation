defmodule Assertion do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro assert({:==, _, [lhs, rhs]}) do
    quote do
      do_assertion(:==, unquote(lhs), unquote(rhs))
    end
  end

  def do_assertion(:==, lhs, rhs) when lhs == rhs do
    IO.puts "."
  end

  def do_assertion(:==, lhs, rhs) do
    IO.puts "Assertion failed!"
    IO.puts "#{inspect(lhs)} is not equal to #{inspect(rhs)}"
  end
end

defmodule TestAssertion do
  use Assertion

  def test do
    File.rm("test.txt")
    assert write_date("test.txt") == :ok
  end

  defp write_date(filename) do
    if not File.exists?(filename) do
      File.write(filename, DateTime.utc_now |> DateTime.to_string)
    end
  end
end
