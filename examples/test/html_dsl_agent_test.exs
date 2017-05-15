defmodule HtmlDslAgentTest do
  use ExUnit.Case

  use HtmlDslAgentWalk

  defp generate_html do
    markup do
      head do
        title do
          text "Hello"
        end
      end
    end
  end

  test "assert generates proper code when the two sides are equal" do
    assert generate_html() == "<head><title>Hello</title></head>"
  end
end
