# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LostLegends.Repo.insert!(%LostLegends.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias LostLegends.Repo
alias LostLegends.{Monster, Battle}

Repo.delete_all Monster
Repo.delete_all Battle

Repo.insert!(%Monster{name: "Crackie Monster", desc: "Drugs are bad mkay.", health: 50})
Repo.insert!(%Monster{name: "That 12th beer", desc: "Today totally isn't Sunday, trust me.", health: 70})
Repo.insert!(%Monster{name: "Rey Kenobi", desc: "The light-side is totally not eval.", health: 50})


Enum.each Repo.all(Monster), fn (x) ->
  Repo.insert! %Battle{monster_id: x.id}
end
