defmodule TimezoneSimple do
  @timezones_path Path.join([__DIR__, "../timezones.csv"])

  @timezones (for timezone <- File.stream!(@timezones_path, [], :line) do
    timezone |> String.trim |> String.split(",") |> Enum.map(&String.trim/1)
  end)

  @timezones
  |> Enum.each(fn [abbrv, name, offset] ->
    timezone_name = (abbrv <> "_name") |> String.downcase |> String.to_atom
    def unquote(timezone_name)() do
      unquote(name)
    end

    timezone_offset = (abbrv <> "_offset") |> String.downcase |> String.to_atom
    def unquote(timezone_offset)() do
      unquote(offset)
      |> Float.parse()
      |> elem(0)
    end
  end)

  def test do
    IO.puts "The offset of #{cest_name()} is #{cest_offset()}"
  end
end
