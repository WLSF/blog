defmodule Blog.Accounts.Validators do
  @moduledoc """
  This module handles all the validators and modifiers
  responsible for the User schema.
  """

  import Ecto.Changeset

  alias Argon2

  # =====================================
  # Display name validators and modifiers
  # =====================================

  @spec display_name(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def display_name(changeset) do
    changeset
    |> validate_length(:display_name, min: 8)
  end

  # ==============================
  # Email validators and modifiers
  # ==============================

  @spec email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def email(changeset) do
    changeset
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/[A-Za-z0-9._]+@[A-Za-z]+(.(com|br))+/)
  end

  # =================================
  # Password validators and modifiers
  # =================================

  @spec password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def password(changeset) do
    changeset
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
