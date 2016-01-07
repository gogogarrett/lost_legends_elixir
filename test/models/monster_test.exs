defmodule LostLegends.MonsterTest do
  use LostLegends.ModelCase

  alias LostLegends.Monster

  @valid_attrs %{desc: "some content", health: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Monster.changeset(%Monster{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Monster.changeset(%Monster{}, @invalid_attrs)
    refute changeset.valid?
  end
end
