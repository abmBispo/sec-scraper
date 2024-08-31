defmodule Khronos.Command do
  alias Ecto.Changeset
  alias Khronos.Errors.ValidationError

  @type t :: struct()

  @callback validate(params :: map()) :: Changeset.t()

  defmacro __using__(_arguments) do
    quote do
      @behaviour Khronos.Command

      use Ecto.Schema

      import Ecto.Changeset

      @spec create(map()) :: {:ok, struct()} | {:error, ValidationError.t()}
      def create(params) do
        Khronos.Command.create(__MODULE__, params)
      end
    end
  end

  @spec create(atom(), map()) :: {:ok, struct()} | {:error, any()}
  def create(module, params) do
    params
    |> module.validate()
    |> Changeset.apply_action(:create)
  end
end
