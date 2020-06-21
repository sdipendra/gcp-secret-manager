defmodule GCPSecretManagerTest do
  use ExUnit.Case
  doctest GCPSecretManager

  test "greets the world" do
    assert GCPSecretManager.hello() == :world
  end
end
