defmodule Mercury.Messagestream do
  @moduledoc """
  The Messagestream context.
  """

  import Ecto.Query, warn: false
  alias Mercury.Repo

  alias Mercury.Messagestream.Personmessage

  @doc """
  Returns the list of personmessages.

  ## Examples

      iex> list_personmessages()
      [%Personmessage{}, ...]

  """
  def list_personmessages(space, self_id, other_id, last_index, page_size) do

    
    query_first = from pm in Personmessage,
      where: ((pm.sender == ^self_id and pm.receiver == ^other_id) or (pm.sender == ^other_id and pm.receiver == ^self_id)),
      order_by: [desc: pm.id],
      limit: ^page_size

    query = from pm in Personmessage,
      where: pm.id < ^last_index and ((pm.sender == ^self_id and pm.receiver == ^other_id) or (pm.sender == ^other_id and pm.receiver == ^self_id)),
      order_by: [desc: pm.id],
      limit: ^page_size

    Repo.all(if(last_index < 0, do: query_first, else: query), prefix: "mercury_#{space}")
  end

  @doc """
  Gets a single personmessage.

  Raises `Ecto.NoResultsError` if the Personmessage does not exist.

  ## Examples

      iex> get_personmessage!(123)
      %Personmessage{}

      iex> get_personmessage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_personmessage!(id), do: Repo.get!(Personmessage, id)

  @doc """
  Creates a personmessage.

  ## Examples

      iex> create_personmessage(%{field: value})
      {:ok, %Personmessage{}}

      iex> create_personmessage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_personmessage(space, attrs) do
    %Personmessage{}
    |> Personmessage.changeset(attrs)
    |> Repo.insert(prefix: "mercury_#{space}")
  end

  @doc """
  Updates a personmessage.

  ## Examples

      iex> update_personmessage(personmessage, %{field: new_value})
      {:ok, %Personmessage{}}

      iex> update_personmessage(personmessage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_personmessage(%Personmessage{} = personmessage, attrs) do
    personmessage
    |> Personmessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a personmessage.

  ## Examples

      iex> delete_personmessage(personmessage)
      {:ok, %Personmessage{}}

      iex> delete_personmessage(personmessage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_personmessage(%Personmessage{} = personmessage) do
    Repo.delete(personmessage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking personmessage changes.

  ## Examples

      iex> change_personmessage(personmessage)
      %Ecto.Changeset{data: %Personmessage{}}

  """
  def change_personmessage(%Personmessage{} = personmessage, attrs \\ %{}) do
    Personmessage.changeset(personmessage, attrs)
  end
end
