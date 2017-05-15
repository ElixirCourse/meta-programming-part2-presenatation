defmodule ExternalResourceGeneration do
  @external_resource tags_path = Path.join([__DIR__, "../tags.csv"])
  @tags (for line <- File.stream!(tags_path, [], :line) do
    line |> String.trim |> String.to_atom
  end)

  for tag_name <- @tags do
    defmacro unquote(tag_name)(do: block) do
      tag_name = unquote(tag_name)
      quote do
        IO.puts "<#{unquote(tag_name)}>"
        unquote(block)
        IO.puts "</#{unquote(tag_name)}>"
      end
    end
  end

  defmacro text(str) do
    quote do
      IO.puts unquote(str)
    end
  end
end

defmodule TestExternalResourceGeneration do
  import ExternalResourceGeneration

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
