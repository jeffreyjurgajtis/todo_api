defmodule TodoApi.TodoControllerTest do
  use TodoApi.ConnCase
  import TodoApi.UserHelper, only: [insert_user: 0]

  alias TodoApi.Todo

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
    insert_todo(user.id)

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

  test "index returns error JSON when auth token is invalid", %{conn: conn} do
    json = conn
            |> put_req_header("x-auth-token", "invalid-token")
            |> get(todo_path(conn, :index))
            |> json_response(401)

    assert(json["error"])
  end

  test "index returns status 401 when auth token is missing", %{conn: conn} do
    response = conn |> get(todo_path(conn, :index))

    assert(response.status == 401)
  end

  test "create returns 201/todo JSON on success", %{conn: conn} do
    {:ok, user} = insert_user
    json = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> post(todo_path(conn, :create), todo: %{content: "content"})
            |> json_response(201)

    assert(json["todo"])
  end

  test "create returns 422/error JSON on failure", %{conn: conn} do
    {:ok, user} = insert_user
    json = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> post(todo_path(conn, :create), todo: %{content: ""})
            |> json_response(422)

    assert(json["errors"] != %{})
  end

  test "show returns 200/todo JSON" do
    {:ok, user} = insert_user
    todo = insert_todo(user.id)

    json = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> get(todo_path(conn, :show, todo.id))
            |> json_response(200)

    assert(json["todo"] == %{
      "id" => todo.id,
      "content" => todo.content,
      "completed_at" => todo.completed_at
    })
  end

  test "update returns 200/todo JSON on success", %{conn: conn} do
    {:ok, user} = insert_user
    todo = insert_todo(user.id)

    json = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> put(todo_path(conn, :update, todo.id), todo: %{content: "new"})
            |> json_response(200)

    assert(json["todo"] == %{
      "id" => todo.id,
      "content" => "new",
      "completed_at" => todo.completed_at
    })
  end

  test "update returns 422/error JSON on failure", %{conn: conn} do
    {:ok, user} = insert_user
    todo = insert_todo(user.id)

    json = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> put(todo_path(conn, :update, todo.id), todo: %{content: ""})
            |> json_response(422)

    assert(json["errors"] != %{})
  end

  test "delete returns status 204", %{conn: conn} do
    {:ok, user} = insert_user
    todo = insert_todo(user.id)

    response = conn
            |> put_req_header("x-auth-token", user.authentication_token)
            |> delete(todo_path(conn, :delete, todo.id))

    assert(response.status == 204)
    refute(Repo.get(Todo, todo.id))
  end

  defp insert_todo(user_id) do
    %Todo{content: "content", user_id: user_id} |> Repo.insert!
  end
end
