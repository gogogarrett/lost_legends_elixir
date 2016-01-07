defmodule LostLegends.Monster do
  use LostLegends.Web, :model

  schema "monsters" do
    field :name, :string
    field :desc, :string
    field :health, :integer

    timestamps
  end

  @required_fields ~w(health)
  @optional_fields ~w(name desc)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
