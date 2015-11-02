defmodule TodoApi.TodoControllerTest do
  use TodoApi.ConnCase

  alias TodoApi.User
  alias TodoApi.Todo
  alias TodoApi.Registration

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "index returns status 200 when auth token is valid", %{conn: conn} do
    {:ok, user} = insert_user

    response = conn
                |> put_req_header("x-auth-token", user.authentication_token)
                |> get(todo_path(conn, :index))

    assert(response.status == 200)
  end

  test "index returns todo JSON on success", %{conn: conn} do
    {:ok, user} = insert_user
    %Todo{content: "content", user_id: user.id} |> Repo.insert!

    json = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> get(todo_path(conn, :index))
            |> json_response(200)

    assert(Enum.count(json["todos"]) == 1)
  end

  test "index returns status 401 when auth token is invalid", %{conn: conn} do
    response = conn
                |> put_req_header("x-auth-token", "invalid-token")
                |> get(todo_path(conn, :index))

    assert(response.status == 401)
  end

  test "index returns status 401 when auth token is missing", %{conn: conn} do
    response = conn |> get(todo_path(conn, :index))

    assert(response.status == 401)
  end

  defp insert_user do
    %User{}
    |> User.changeset(%{email: "email@example.com", password: "password"})
    |> Registration.create
  end
end
