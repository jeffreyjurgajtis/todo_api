defmodule TodoApi.UserController do
  use TodoApi.Web, :controller

  alias TodoApi.User
  alias TodoApi.Registration
  alias TodoApi.ChangesetView

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case changeset.valid? do
      true ->
        register_user(conn, changeset)
      _ ->
        conn
        |> put_status(422)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp register_user(conn, changeset) do
    case Registration.create(changeset) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> render("user.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end
end
