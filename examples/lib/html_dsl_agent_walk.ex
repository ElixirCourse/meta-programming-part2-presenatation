defmodule HtmlDslAgentWalk do
  @external_resource tags_path = Path.join([__DIR__, "../tags.csv"])
  @tags (for line <- File.stream!(tags_path, [], :line) do
    line |> String.trim |> String.to_atom
  end)

  defmacro __using__(_options) do
    quote do
      import(unquote(__MODULE__))
    end
  end

  defmacro markup(do: block) do
    quote do
      {:ok, var!(buffer, HtmlDslAgentWalk)} = Agent.start(fn -> [] end)
      unquote(Macro.postwalk(block, &postwalk/1))
      result = render(var!(buffer, HtmlDslAgentWalk))
      :ok = Agent.stop(var!(buffer, HtmlDslAgentWalk))
      result
    end
  end

  def postwalk({:text, _meta, [str]}) do
    quote do
      output(var!(buffer, HtmlDslAgentWalk), unquote(str))
    end
  end

  def postwalk({tag_name, _meta, [[do: block]]}) when tag_name in @tags do
    generate_tag(tag_name, do: block)
  end

  def postwalk(ast), do: ast

  def generate_tag(tag_name, do: inner) do
    quote do
      output(var!(buffer, HtmlDslAgentWalk), "<#{unquote(tag_name)}>")
      unquote(inner)
      output(var!(buffer, HtmlDslAgentWalk), "</#{unquote(tag_name)}>")
    end
  end

  def output(buffer, str) do
    Agent.update(buffer, &[str | &1])
  end

  def render(buffer) do
    IO.iodata_to_binary(Agent.get(buffer, &(&1)) |> Enum.reverse)
  end
end

defmodule TestHtmlDslAgentWalk do
  use HtmlDslAgentWalk

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
