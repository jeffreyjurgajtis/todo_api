defmodule TodoApi.AuthenticationControllerTest do
  use TodoApi.ConnCase

  alias TodoApi.User
  alias TodoApi.Registration

  @user_params %{email: "email@example.com", password: "password"}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "create returns status 201 on success", %{conn: conn} do
    insert_user
    response = conn |> post("/authentication", %{user: @user_params})

    assert response.status == 201
  end

  test "create returns user JSON on success", %{conn: conn} do
    {:ok, user} = insert_user

    response_json = conn
    |> post("/authentication", %{user: @user_params})
    |> json_response(201)

    assert response_json == %{
      "id" => user.id,
      "email" => user.email,
      "authentication_token" => user.authentication_token
    }
  end

  test "create returns status 400 on auth failure", %{conn: conn} do
    {:ok, user} = insert_user
    invalid_params = %{email: user.email, password: "invalid"}

    response = conn |> post("/authentication", %{user: invalid_params})

    assert response.status == 400
  end

  test "create returns error JSON on auth failure", %{conn: conn} do
    {:ok, user} = insert_user
    invalid_params = %{email: user.email, password: "invalid"}

    response_json = conn
    |> post("/authentication", %{user: invalid_params})
    |> json_response(400)

    assert response_json["error"] == "invalid password/email combination"
  end

  test "create returns status 400 when email is invalid", %{conn: conn} do
    invalid_params = %{email: "invalid@email.com", password: "password"}

    response = conn |> post("/authentication", %{user: invalid_params})

    assert response.status == 400
  end

  test "create returns error JSON when email is invalid", %{conn: conn} do
    invalid_params = %{email: "invalid@email.com", password: "password"}

    response_json = conn
    |> post("/authentication", %{user: invalid_params})
    |> json_response(400)

    assert response_json["error"] == "invalid password/email combination"
  end

  test "create returns status 400 when password is missing", %{conn: conn} do
    response = conn
    |> post("/authentication", %{user: %{email: "email@example.com"}})

    assert response.status == 400
  end

  test "create returns error JSON when password is missing", %{conn: conn} do
    response_json = conn
    |> post("/authentication", %{user: %{email: "email@example.com"}})
    |> json_response(400)

    assert response_json["error"] == "email/password are required"
  end

  defp insert_user do
    %User{} |> User.changeset(@user_params) |> Registration.create
  end
end
