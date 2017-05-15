defmodule HtmlDslTest do
  use ExUnit.Case

  require HtmlDsl

  test "assert generates proper code when the two sides are equal" do
    assert Macro.to_string(HtmlDsl.generate_tag(:head, do: quote(do: HtmlDsl.text("test")))) == String.strip(~S"""
    (
      output("<#{:head}>")
      HtmlDsl.text("test")
      output("</#{:head}>")
    )
    """)
  end
end
