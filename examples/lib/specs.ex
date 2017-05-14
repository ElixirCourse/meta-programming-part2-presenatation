defmodule Specs do
  defmacro __using__(_options) do
    quote do
      use Assertion

      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :specs, accumulate: true)
    end
  end

  defmacro spec(description, do: spec_block) do
    func_name = String.to_atom(description)
    quote do
      @specs {unquote(func_name), unquote(description)}
      def unquote(func_name)(), do: unquote(spec_block)

      IO.inspect("Current specs: #{inspect(@specs)}")
    end
  end
end

defmodule TestSpecs do
  use Specs

  spec "Test truth" do
    assert true == true
  end

  spec "Test failure" do
    assert false == true
  end
end
