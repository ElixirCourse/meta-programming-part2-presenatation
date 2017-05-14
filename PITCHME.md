### Мета програмиране част 2

Валентин Михов

#HSLIDE

### Прост пример за мета програмиране - unless

```elixir
defmodule Cond do
  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end
```

#HSLIDE

### Използване на using

```elixir
defmodule Cond do
  defmacro __using__(_options) do
    import Kernel, except: [unless: 2]
    import unquote(__MODULE__), only: [unless: 2]
  end

  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end
```

#HSLIDE

```elixir
defmodule TestUnless do
  use Cond

  def test do
    unless File.exists?("test.txt") do
      File.write("test.txt", DateTime.utc_now |> DateTime.to_string)
    end
  end
end
```

#HSLIDE

### bind_quoted

Assertion example

#HSLIDE

### Compile-time hooks

* Възможно е да дефинираме функция която се вика в края на компилацията на модула
* Spec runner example
