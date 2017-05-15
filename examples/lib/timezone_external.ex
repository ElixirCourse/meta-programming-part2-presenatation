defmodule TimezoneExternal do
  HTTPoison.start

  "https://gist.githubusercontent.com/valo/c07f8db33d223f57a4cc9c670e1b6050/raw/2f47e8d567aafcaab9ed9cf1b90e21db09a57532/timezones.csv"
  |> HTTPoison.get!
  |> Map.get(:body)
  |> String.split("\n")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split(&1, ","))
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
    IO.puts "The offset of #{pst_name()} is #{pst_offset()}"
  end
end
