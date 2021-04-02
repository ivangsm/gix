defmodule Gix.Workspace do
  @moduledoc """
  An Elixir implementation of Git version control system
  """

  alias Gix.Helpers

  def list_files do
    list = Path.wildcard("./*")

    Enum.map(list, fn path -> Helpers.ls_r(path) end)
    |> List.flatten()
  end
end
