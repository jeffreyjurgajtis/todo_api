defmodule TodoApi.TodoTest do
  use TodoApi.ModelCase

  alias TodoApi.Todo
  alias TodoApi.Repo

  test "changeset valid? returns true when content and user_id are present" do
    attrs = %{content: "content", user_id: 1}
    changeset = Todo.changeset(%Todo{}, attrs)

    assert changeset.valid?
  end

  test "validations require content to be present" do
    attrs = %{content: ""}
    changeset = Todo.changeset(%Todo{}, attrs)
    {message, _count} = changeset.errors[:content]

    assert message == "should be at least %{count} characters"
  end

  test "insert ensures user_id is associated with existing user" do
    attrs = %{completed_at: Ecto.DateTime.local, content: "hey", user_id: 123}
    {:error, changeset} = %Todo{} |> Todo.changeset(attrs) |> Repo.insert

    assert changeset.errors[:user] == "does not exist"
  end

  test "when completed_at is already set and a parseable datetime is passed in" do
    todo = TodoApi.TodoHelper.insert_completed_todo
    str  = "2015-11-04T19:37:19.455Z"
    changeset = Todo.changeset(todo, %{completed_at: str})

    assert changeset.valid?
    assert :completed_at in Map.keys(changeset.changes)
  end

  test "when completed_at is already set and a non-parseable datetime is passed in" do
    todo = TodoApi.TodoHelper.insert_completed_todo
    str  = "2015-11-04T19:37:19+00:00"
    changeset = Todo.changeset(todo, %{completed_at: str})

    refute changeset.valid?
    assert changeset.errors[:completed_at] == "is invalid"
  end
end
