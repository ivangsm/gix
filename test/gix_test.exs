defmodule GixTest do
  use ExUnit.Case
  doctest Gix

  test "greets the world" do
    assert Gix.hello() == :world
  end
end
