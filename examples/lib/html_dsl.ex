defmodule HtmlDsl do
  @external_resource tags_path = Path.join([__DIR__, "../tags.csv"])
  @tags (for line <- File.stream!(tags_path, [], :line) do
    line |> String.trim |> String.to_atom
  end)

  for tag_name <- @tags do
    defmacro unquote(tag_name)(do: block) do
      generate_tag(unquote(tag_name), do: block)
    end
  end

  defmacro text(str) do
    quote do
      output unquote(str)
    end
  end

  def generate_tag(tag_name, do: inner) do
    quote do
      output "<#{unquote(tag_name)}>"
      unquote(inner)
      output "</#{unquote(tag_name)}>"
    end
  end

  def output(str) do
    IO.puts(str)
  end
end

defmodule TestHtmlDsl do
  import HtmlDsl

  def test do
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
