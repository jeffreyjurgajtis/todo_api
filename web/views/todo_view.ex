defmodule TodoApi.TodoView do
  use TodoApi.Web, :view

  def render("index.json", %{todos: todos}) do
    %{todos: render_many(todos, TodoApi.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{todos: render_one(todo, TodoApi.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      content: todo.content,
      completed_at: todo.completed_at
    }
  end
end
