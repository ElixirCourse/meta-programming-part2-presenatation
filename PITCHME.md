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
    import unquote(__MODULE__), only: [fmi_unless: 2]
  end

  defmacro fmi_unless(expr, do: block) do
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
    fmi_unless File.exists?("test.txt") do
      File.write("test.txt", DateTime.utc_now |> DateTime.to_string)
    end
  end
end
```

#HSLIDE

### bind_quoted

Assertion example

#HSLIDE

### Изплзване на модулни атрибути по време на компилация

Specs example

#HSLIDE

### Compile-time hooks

* Възможно е да дефинираме функция която се вика в края на компилацията на модула
* Spec runner example

#HSLIDE

### Генериране на функции от външен файл

Timezones example

#HSLIDE

### Генериране на функции от външен URL

Timezone example from a GIST

#HSLIDE

### Testing

* Тествайте генерираният код, не генерирането на код
* a.k.a. integration testing
* Тестването на генерираният AST и междинните стъпки е много трудно
* Пример със timezones

#HSLIDE

### Да имплементираме HTML DSL

Имплементация чрез IO.puts

#HSLIDE

### Unit Testing

* Тестване на самото AST трябва да се прави само при много специални случаи
* Може да стане, ако делегираме контрола на нормални функции генериращи AST
* Macro.to_string - връща кода на дадено AST
* Така можем да тестваме с най-просто равенство

#HSLIDE

### Да имплементираме HTML DSL

Имплементация чрез агент

#HSLIDE

### Macro.prewalk && Macro.postwalk

* Можем да имплементираме горният пример чрез обхождане на AST-то
* Така можем да намалим количеството код, което генерираме
* За сметка на това трябва да работим на много по-ниско ниво

#HSLIDE

### Въпроси?

![Logo](assets/questions.jpg)
