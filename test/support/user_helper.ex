defmodule TodoApi.UserHelper do
  alias TodoApi.User
  alias TodoApi.Registration

  @user_params %{email: "email@example.com", password: "password"}

  def insert_user(user_params \\ @user_params) do
    %User{} |> User.changeset(user_params) |> Registration.create
  end
end
