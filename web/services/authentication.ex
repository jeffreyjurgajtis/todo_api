defmodule TodoApi.Authentication do
  alias TodoApi.Repo
  alias TodoApi.User

  def get_user(authentication_token) when is_binary(authentication_token) do
    user = Repo.get_by(User, authentication_token: authentication_token)

    case user do
      %User{} ->
        {:ok, user}
      _ ->
        {:error, "cannot find user by authentication token"}
    end
  end

  def get_user(_) do
    {:error, "a valid authentication token is required"}
  end
end
