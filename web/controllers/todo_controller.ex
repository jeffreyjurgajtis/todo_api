defmodule TodoApi.TodoController do
  use TodoApi.Web, :controller

  alias TodoApi.Authentication
  alias TodoApi.Todo
  alias TodoApi.Repo
  alias TodoApi.ChangesetView

  plug :authenticate_user

  def index(conn, _params) do
    user = conn.assigns[:user]
    todos = Repo.all(Todo, user_id: user.id)

    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    user = conn.assigns[:user]
    params = Map.put(todo_params, "user_id", user.id)
    changeset = Todo.changeset(%Todo{}, params)

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> render("show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp authenticate_user(conn, _) do
    authentication_token = conn.req_headers["x-auth-token"]

    case Authentication.get_user(authentication_token) do
      {:ok, user} ->
        assign(conn, :user, user)
      {:error, message} ->
        conn |> put_status(401) |> json(%{error: message}) |> halt
    end
  end
end
