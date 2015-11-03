defmodule TodoApi.Todo do
  use TodoApi.Web, :model

  schema "todos" do
    field :content, :string
    field :completed_at, Ecto.DateTime
    belongs_to :user, TodoApi.User

    timestamps
  end

  @required_fields ~w(content user_id)
  @optional_fields ~w(completed_at)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:content, min: 1)
    |> assoc_constraint(:user)
  end

  def sorted(query \\ __MODULE__) do
    from t in query,
    order_by: [asc: t.inserted_at]
  end
end
