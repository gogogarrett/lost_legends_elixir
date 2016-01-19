import {Socket} from "deps/phoenix/web/static/js/phoenix"

function updateUserList(users = []) {
  $('.players').empty()
  users.forEach(user => {
    $('.players').append(`<li>${user.id} : ${user.name}</li>`)
  })
}

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel('battle:1', {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

// channel.on("load_monster_info", payload => {
//   $('.monster-name').text(payload.name)
//   $('.monster-desc').text(payload.desc)
//   $('.monster-health').text(payload.health)
// })

// $('.attack').on('click', event => {
//   event.preventDefault();

//   let userId = Math.ceil(Math.random() * (5 - 1) + 1);
//   let damageAmount = Math.ceil(Math.random() * (100 - 2) + 2);

//   channel.push(`attack:${userId}`, {damage: damageAmount})
// })

// channel.on('attack', payload => {
//   $('.combat-area').append(`<br/> Player ${payload.user_id} attacked for ${payload.damage} damage!`)
//   $('.monster-health').text(payload.monster_health)
// })

// channel.on('monster_kill', payload => {
//   $('.combat-area').append(`<br/> Player ${payload.user_id} KILLED THE BOSS`)
//   $('.monster-health').text(payload.monster_health)
// })

channel.on('user:joined', payload => { updateUserList(payload.users) })
channel.on('user:left',   payload => { updateUserList(payload.users) })


export default socket
