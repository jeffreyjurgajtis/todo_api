defmodule TodoApi.AuthenticationTest do
  use TodoApi.ModelCase

  alias TodoApi.User
  alias TodoApi.Registration
  alias TodoApi.Authentication

  @user_params %{email: "email@example.com", password: "password"}

  test "returns {:ok, user} when a valid token is given" do
    {:ok, user} = %User{}
                  |> User.changeset(@user_params)
                  |> Registration.create

    {:ok, result} = Authentication.get_user(user.authentication_token)

    assert user.email == result.email
  end

  test "returns {:error} when an invalid token is given" do
    error_msg = "cannot find user by authentication token"

    assert {:error, error_msg} == Authentication.get_user("invalid-token")
  end
end
