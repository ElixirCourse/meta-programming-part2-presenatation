defmodule SpecRunner do
  defmacro __using__(_options) do
    quote do
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        @specs
        |> Enum.each(fn {spec_func, spec_desc} ->
          IO.puts "Running spec: #{spec_desc}"
          apply(__MODULE__, spec_func, [])
          IO.puts ""
        end)
      end
    end
  end
end
