defmodule HtmlDslAgent do
  @external_resource tags_path = Path.join([__DIR__, "../tags.csv"])
  @tags (for line <- File.stream!(tags_path, [], :line) do
    line |> String.trim |> String.to_atom
  end)

  defmacro __using__(_options) do
    quote do
      import(unquote(__MODULE__))
    end
  end

  for tag_name <- @tags do
    defmacro unquote(tag_name)(do: block) do
      tag(unquote(tag_name), do: block)
    end
  end

  defmacro text(str) do
    quote do
      output(var!(buffer, HtmlDslAgent), unquote(str))
    end
  end

  defmacro markup(do: block) do
    quote do
      {:ok, var!(buffer, HtmlDslAgent)} = Agent.start(fn -> [] end)
      unquote(block)
      result = render(var!(buffer, HtmlDslAgent))
      :ok = Agent.stop(var!(buffer, HtmlDslAgent))
      result
    end
  end

  def tag(tag_name, do: inner) do
    quote do
      output(var!(buffer, HtmlDslAgent), "<#{unquote(tag_name)}>")
      unquote(inner)
      output(var!(buffer, HtmlDslAgent), "</#{unquote(tag_name)}>")
    end
  end

  def output(buffer, str) do
    Agent.update(buffer, &[str | &1])
  end

  def render(buffer) do
    IO.iodata_to_binary(Agent.get(buffer, &(&1)) |> Enum.reverse)
  end
end

defmodule TestHtmlDslAgent do
  use HtmlDslAgent

  def test do
    markup do
      html do
        head do
          title do
            text "Hello from HTML DSL!"
          end
        end

        body do
          p do
            text "Writing HTML with elixir code is awesome!"
          end
        end
      end
    end
  end
end
