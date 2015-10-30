defmodule TodoApi.UserControllerTest do
  use TodoApi.ConnCase

  @user_params %{email: "email@example.com", password: "password"}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "create returns status 201 on success", %{conn: conn} do
    response = conn |> post("/users", %{user:  @user_params})

    assert(response.status == 201)
  end

  test "create returns user JSON on success", %{conn: conn} do
    json_body = conn 
    |> post("/users", %{user:  @user_params})
    |> json_response(201)

    assert json_body["id"]
    assert json_body["email"]
    assert json_body["authentication_token"]
  end

  test "create returns status 400 on failure", %{conn: conn} do
    response = conn |> post("/users", %{user:  %{}})

    assert(response.status == 422)
  end

  test "create returns error JSON on success", %{conn: conn} do
    json_body = conn 
    |> post("/users", %{user:  %{user: %{}}})
    |> json_response(422)

    assert json_body["errors"]
  end
end
