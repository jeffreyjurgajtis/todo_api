defmodule TodoApi.UserView do
  use TodoApi.Web, :view

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      authentication_token: user.authentication_token}
  end
end
