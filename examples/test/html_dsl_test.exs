defmodule HtmlDslTest do
  use ExUnit.Case

  require HtmlDsl

  defp generate_ast do
    HtmlDsl.tag(:head) do
      quote do
        HtmlDsl.text("test")
      end
    end
  end

  test "assert generates proper code when the two sides are equal" do
    assert Macro.to_string(generate_ast()) == String.strip(~S"""
    (
      output("<#{:head}>")
      HtmlDsl.text("test")
      output("</#{:head}>")
    )
    """)
  end
end
