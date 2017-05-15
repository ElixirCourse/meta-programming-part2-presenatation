defmodule TimezoneExternalTest do
  use ExUnit.Case

  test "the PST timezone is described correctly" do
    assert TimezoneExternal.pst_name() == "Pacific Standard Time (North America)"
    assert TimezoneExternal.pst_offset() == -8.0
  end

  test "the EEST timezone is described correctly" do
    assert TimezoneExternal.eest_name() == "Eastern European Summer Time"
    assert TimezoneExternal.eest_offset() == 3.0
  end
end
