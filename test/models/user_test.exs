defmodule TodoApi.UserTest do
  use TodoApi.ModelCase

  alias TodoApi.User
  alias TodoApi.Repo

  test "changeset valid? returns true with valid attributes" do
    valid_attrs = %{email: "email@example.com", password: "password"}
    changeset = User.changeset(%User{}, valid_attrs)

    assert changeset.valid?
  end

  test "validations require password to be a minimum of 5 characters" do
    invalid_attrs = %{email: "email@example.com", password: "asdf"}
    changeset = User.changeset(%User{}, invalid_attrs)

    assert changeset.errors[:password]
  end

  test "validations require email to be unique" do
    {:ok, first_user} = %User{}
    |> User.changeset(%{email: "email@example.com", password: "password"})
    |> Ecto.Changeset.put_change(:crypted_password, "hash")
    |> Ecto.Changeset.put_change(:authentication_token, "token")
    |> Repo.insert

    {:error, changeset} = %User{}
    |> User.changeset(%{email: first_user.email, password: "rubyconf"})
    |> Ecto.Changeset.put_change(:crypted_password, "crypted_password")
    |> Ecto.Changeset.put_change(:authentication_token, "auth-token")
    |> Repo.insert

    assert changeset.errors[:email] == "has already been taken"
  end
end
