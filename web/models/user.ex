defmodule TodoApi.User do
  use TodoApi.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :authentication_token, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
  end
end
