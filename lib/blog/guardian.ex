defmodule Blog.Guardian do
  use Guardian, otp_app: :blog

  alias Blog.Accounts

  def subject_for_token(user, _claims), do: {:ok, to_string(user.id)}

  def resource_from_claims(%{"sub" => id}) do
    {:ok, Accounts.get_user!(id)}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end
end
