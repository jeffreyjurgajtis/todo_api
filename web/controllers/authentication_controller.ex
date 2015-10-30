defmodule TodoApi.AuthenticationController do
  use TodoApi.Web, :controller

  alias TodoApi.User
  alias TodoApi.Repo
  alias TodoApi.UserView
  alias Comeonin.Bcrypt

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)

    checkpw(conn, password, user)
  end

  def create(conn, _) do
    conn |> put_status(400) |> json(%{error: "email/password are required"})
  end

  defp checkpw(conn, password, user = %User{}) do
    case Bcrypt.checkpw(password, user.crypted_password) do
      true ->
        conn
        |> put_status(201)
        |> render(UserView, "user.json", user: user)
      _ ->
        conn
        |> put_status(400)
        |> json(%{error: "invalid password/email combination"})
    end
  end

  defp checkpw(conn, _password, _user = nil) do
    conn
    |> put_status(400)
    |> json(%{error: "invalid password/email combination"})
  end
end
