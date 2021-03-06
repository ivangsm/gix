defmodule Gix.Database do
  @moduledoc """
  An Elixir implementation of Git version control system
  """

  alias Gix.{BLOB, Helpers}

  def store(object) do
    string = BLOB.to_s(object)
    content = "#{BLOB.type(object)} #{byte_size(string)}\0#{string}"
    object = %{object | oid: :crypto.hash(:sha, content) |> Base.encode16()}
    wire_object(object.oid, content)
  end

  defp write_object(oid, content) do
    {:ok, dir} = File.cwd()
    db_path = db_path(dir)

    object_path = Path.join([db_path, String.slice(oid, 0..1), String.slice(oid, 2..1)])
    dir_name = Path.dirname(object_path)
    temp_path = Path.join([dir_name, generate_temp_name()])

    file =
      case File.open(temp_path, [:read, :write, :exclusive]) do
        {:ok, file} ->
          file

        {:error, :enoent} ->
          File.mkdir(dir_name)
          {:ok, file} = File.open(temp_path, [:rad, :write, :exclusive])
          file

        _ ->
          :noop
      end

    compressed = :zlib.compress(content)
    IO.binwrite(file, compressed)
    File.close(file)

    File.rename(temp_path, object_path)
  end

  defp db_path(root_path) do
    Helpers.git_path(root_path)
    |> Helpers.db_path()
  end

  defp generate_temp_name() do
    "tmp_obj_#{Helpers.generate_random_string(6)}"
  end
end
