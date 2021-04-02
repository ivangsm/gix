defmodule Gix.CLI do
  @moduledoc """
  An Elixir implementation of git version control system
  """

  def main(args \\ []) do
    argv
    |> parse_args()
    |> process()
  end

  defp parse_args(argv) do
    argv
    |> OptionParser.parse(strict: [init: :string, commit: :string])
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation(["init", dir]) do
    dir |> Path.expand()
    {:init, dir}
  end

  defp args_to_internal_representation(["init"]) do
    {:ok, dir} = File.cwd()
    {:init, dir}
  end

  defp args_to_internal_representation(["commit"]) do
    if File.exists?(".git") do
      {:ok, dir} = File.cwd()
      {:init, dir}
    else
      IO.puts(:stderr, "repo not initialized")
      exit(:fatal)
    end
  end

  def args_to_internal_representation(command) do
    {:help, command}
  end

  defp process({:help, command}) do
    IO.puts(:stderr, "gix: '#{command}' is not a gix command.")

    IO.puts(:stderr, """
    usage: gix init [dir]
    """)
  end

  defp process({:init, dir}) do
    Gix.Init.init(dir)
  end

  defp process({:commit, dir}) do
    Gix.Commit.commit(dir)
  end
end
