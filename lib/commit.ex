defmodule Gix.Commit do
  @moduledoc """
  An Elixir implementation of Git version control system
  """

  alias Gix.{Helpers, Workspace, BLOB, Database}

  def commit(_root_path) do
    Workspace.list_files()
    |> Enum.each(fn file ->
      case File.read(file) do
        {:ok, data} ->
          %BLOB{data: data}
          |> Database.store()

        {:error, _} ->
          :noop
      end
    end)
  end
end
