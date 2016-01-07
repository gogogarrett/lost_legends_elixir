ExUnit.start

Mix.Task.run "ecto.create", ~w(-r LostLegends.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r LostLegends.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(LostLegends.Repo)

