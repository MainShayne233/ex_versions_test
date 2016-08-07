{:ok, original} = File.read "README.md"
split = String.split original, "## Dependency Versions:"
dependencies = [
                ["Elixir", "elixir -v"],
                ["Phoenix", "mix phoenix.new -v"],
                ["Postgres", "pg_config --version"],
               ]
versions = Enum.map dependencies, fn(dep) ->
                                    title = "### #{Enum.at(dep, 0)}:"
                                    [cmd | args] = String.split Enum.at(dep, 1), " "
                                    IO.inspect cmd
                                    IO.inspect args
                                    {version, 0} = System.cmd(cmd, args)
                                    "### #{Enum.at(dep, 0)}:\n" <>
                                    "```bash\n# via #{Enum.at(dep, 1)}\n#{version}```"
                                  end
IO.inspect versions
IO.inspect Enum.join versions, "\n"
updated = Enum.at(split, 0) <>
          "## Dependency Versions:\n" <>
          Enum.join(versions, "\n")<>
          Enum.at(split, 1)
{:ok, new_file} = File.open "NEW.md", [:write]
IO.binwrite new_file, updated
File.close new_file
