defmodule Blog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :display_name, :string
      add :email, :string
      add :image, :string
      add :password_hash, :string

      timestamps()
    end
  end
end

