defmodule TodoApi.AuthenticationTest do
  use TodoApi.ModelCase
  import TodoApi.UserHelper, only: [insert_user: 0]

  alias TodoApi.Authentication

  test "returns {:ok, user} when a valid token is given" do
    {:ok, user} = insert_user
    {:ok, result} = Authentication.get_user(user.authentication_token)

    assert user.email == result.email
  end

  test "returns {:error, message} when an invalid token is given" do
    error_msg = "cannot find user by authentication token"

    assert {:error, error_msg} == Authentication.get_user("invalid-token")
  end

  test "returns {:error, message} when an invalid token is missing" do
    error_msg = "a valid authentication token is required"

    assert {:error, error_msg} == Authentication.get_user(nil)
  end
end
