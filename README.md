# LostLegends

A real time multiplayer boss fight.

Join together with up to 4 players to fight against a random boss with a final fantasy style gameplay.


## Super awesome sketch

![lost-legends-sketch](https://cloud.githubusercontent.com/assets/873687/12693230/faa39196-c758-11e5-9d07-de90eaf0d656.png)


## Getting Started

- `mix deps.get`
- `mix ecto.create && mix ecto.migrate`
- `mix run priv/repo/seeds.exs`
- `mix phoenix.server`
- visit [`localhost:4000`](http://localhost:4000) from your browser

## TODO

- [ ] Seed player accounts + use plug/sessions to allow players to play a game
- [ ] Create a lobby with current battles (waiting for people) or start a new battle
- [ ] Start game even if there isn't 4 players after an amount of time
- [ ] randomly select a monster for the battle
- Game Mechanics
  - Boss
    - [ ] Boss attacking random person every (x) seconds
    - [ ] Boss attacking entire group every (y) seconds
    - [ ] Boss healing at low health every (z) seconds
  - Player
    - [ ] Ability to attack boss every (x) seconds (on a cooldown on frontend+backend)
    - [ ] Ability to heal self every (y) seconds (on a cooldown on frontend+backend)
    - [ ] Ability to heal group (z) seconds (on a cooldown on frontend+backend)
  - [ ] Show all the actions the players make in a `battle log` on the page

## TODO Later

- [ ] Hook up user/player accounts (maybe signup with twitter?)
- [ ] n `gen_fsm`s per Channel (instead of 1 `gen_fsm` for everything)
