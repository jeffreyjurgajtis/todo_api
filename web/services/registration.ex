defmodule TodoApi.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  alias TodoApi.Repo
  alias Comeonin.Bcrypt

  def create(changeset) do
    changeset
    |> put_change(:crypted_password, hashed_password(changeset.params["password"]))
    |> put_change(:authentication_token, Bcrypt.gen_salt)
    |> Repo.insert
  end

  defp hashed_password(password) do
    Bcrypt.hashpwsalt(password)
  end
end
