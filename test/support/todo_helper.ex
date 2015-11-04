defmodule TodoApi.TodoHelper do
  alias TodoApi.Todo
  alias TodoApi.Repo

  import TodoApi.UserHelper, only: [insert_user: 0]

  def insert_todo do
    {:ok, user} = insert_user
    insert_todo(user: user)
  end

  def insert_todo(user: user),
  do: insert_todo(%{content: "some content"}, user: user)

  def insert_todo(params = %{content: _content}, user: user) do
    {:ok, todo} = %Todo{}
    |> Todo.changeset(Map.merge(params, %{user_id: user.id}))
    |> Repo.insert

    todo
  end

  def insert_completed_todo do
    {:ok, user} = insert_user
    insert_completed_todo(user: user)
  end

  def insert_completed_todo(user: user) do
    insert_todo(%{content: "some content", completed_at: Ecto.DateTime.local}, user: user)
  end
end
