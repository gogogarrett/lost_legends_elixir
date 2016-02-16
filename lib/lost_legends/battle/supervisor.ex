defmodule LostLegends.Battle.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_child(battle_id) do
    Supervisor.start_child(__MODULE__, [battle_id])
  end

  def init(:ok) do
    children = [worker(LostLegends.Battle.StateMachine, [])]

    supervise(children, strategy: :simple_one_for_one)
  end
end
