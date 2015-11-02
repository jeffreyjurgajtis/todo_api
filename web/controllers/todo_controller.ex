defmodule TodoApi.TodoController do
  use TodoApi.Web, :controller

  alias TodoApi.Authentication
  alias TodoApi.Todo
  alias TodoApi.Repo

  plug :authenticate_user

  def index(conn, _params) do
    user = conn.assigns[:user]
    todos = Repo.all(Todo, user_id: user.id)

    render(conn, "index.json", todos: todos)
  end

  defp authenticate_user(conn, _) do
    authentication_token = conn.req_headers["x-auth-token"]

    case Authentication.get_user(authentication_token) do
      {:ok, user} ->
        assign(conn, :user, user)
      {:error, _message} ->
        conn |> put_status(401) |> halt
    end
  end
end
