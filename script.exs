{:ok, file} = File.read "README.md"
case String.split file, "<!-- ex_versions -->" do
  [_] ->
    IO.puts "Missing <!-- ex_versions > from README\n" <>
            "I need this to know where to put the versions!\n"
  [first_chunk, second_chunk] ->
    [top, bottom] = [first_chunk, second_chunk]
  [first_chunk, middle, second_chunk] ->
    [top, _, bottom] = [first_chunk, middle, second_chunk]

end


dependencies = [
                ["Elixir", "elixir -v"],
                ["Phoenix", "mix phoenix.new -v"],
                ["Postgres", "pg_config --version"],
               ]
versions = Enum.map dependencies, fn(dep) ->
                                    title = "### #{Enum.at(dep, 0)}:"
                                    [cmd | args] = String.split Enum.at dep, 1
                                    IO.inspect cmd
                                    IO.inspect args
                                    {version, 0} = System.cmd(cmd, args)
                                    "### #{Enum.at(dep, 0)}:\n" <>
                                    "```bash\n$ #{Enum.at(dep, 1)}\n\n#{version}```"
                                  end
IO.inspect versions
IO.inspect Enum.join versions, "\n"
updated = top <>
          "<!-- ex_versions -->\n" <>
          "## Dependency Versions:\n" <>
          Enum.join(versions, "\n") <>
          "\n<!-- ex_versions -->" <>
          bottom
{:ok, new_file} = File.open "README.md", [:write]
IO.binwrite new_file, updated
File.close new_file
