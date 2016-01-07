defmodule LostLegends.BattleTest do
  use LostLegends.ModelCase

  alias LostLegends.Battle

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Battle.changeset(%Battle{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Battle.changeset(%Battle{}, @invalid_attrs)
    refute changeset.valid?
  end
end
