defmodule ExVersions do
  def watch dependencies do
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
    deps = sort dependencies

    versions = Enum.map deps, fn(dep) ->
                                {name, cmd_line} = dep
                                [cmd | args] = String.split cmd_line
                                {version, 0} = System.cmd(cmd, args)
                                "### #{name}:\n" <>
                                "```bash\n$ #{cmd_line}\n\n#{version}```"
                              end

    updated = top <>
              "<!-- ex_versions -->\n" <>
              "## Dependency Versions:\n" <>
              Enum.join(versions, "\n") <>
              "\n<!-- ex_versions -->" <>
              bottom

    {:ok, new_file} = File.open "README.md", [:write]
    IO.binwrite new_file, updated
    File.close new_file
  end

  def sort deps do
    Enum.sort deps, &(dep_name(&1) < dep_name(&2))
  end

  def dep_name dep do
    {name, _} = dep
    String.capitalize name
  end
end

# {:ok, file} = File.read "README.md"
# case String.split file, "<!-- ex_versions -->" do
#   [_] ->
#     IO.puts "Missing <!-- ex_versions > from README\n" <>
#             "I need this to know where to put the versions!\n"
#   [first_chunk, second_chunk] ->
#     [top, bottom] = [first_chunk, second_chunk]
#   [first_chunk, middle, second_chunk] ->
#     [top, _, bottom] = [first_chunk, middle, second_chunk]
# end
#
#
# dependencies = [
#                 {"Elixir", "elixir -v"},
#                 {"Phoenix", "mix phoenix.new -v"},
#                 {"npm", "npm -v"},
#                 {"Postgres", "pg_config --version"},
#                ]
#
#
# versions = Enum.map dependencies, fn(dep) ->
#                                     title = "### #{Enum.at(dep, 0)}:"
#                                     [cmd | args] = String.split Enum.at dep, 1
#                                     {version, 0} = System.cmd(cmd, args)
#                                     "### #{Enum.at(dep, 0)}:\n" <>
#                                     "```bash\n$ #{Enum.at(dep, 1)}\n\n#{version}```"
#                                   end
#
# updated = top <>
#           "<!-- ex_versions -->\n" <>
#           "## Dependency Versions:\n" <>
#           Enum.join(versions, "\n") <>
#           "\n<!-- ex_versions -->" <>
#           bottom
#
# {:ok, new_file} = File.open "README.md", [:write]
# IO.binwrite new_file, updated
# File.close new_file
