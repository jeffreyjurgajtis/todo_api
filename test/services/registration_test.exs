defmodule TodoApi.RegistrationTest do
  use TodoApi.ModelCase

  alias TodoApi.User
  alias TodoApi.Registration

  @user_params %{ email: "email@example.com", password: "password" }

  test "create sets a crypted password before insert" do
    changeset = User.changeset(%User{}, @user_params)
    {:ok, user} = Registration.create(changeset)

    assert user.crypted_password
  end

  test "create sets an authentication token before insert" do
    changeset = User.changeset(%User{}, @user_params)
    {:ok, user} = Registration.create(changeset)

    assert user.authentication_token
  end

  test "create saves user to database" do
    changeset = User.changeset(%User{}, @user_params)
    {:ok, user} = Registration.create(changeset)

    assert user.id
  end
end
