import {Socket} from "deps/phoenix/web/static/js/phoenix"

function updatePlayerList(players = []) {
  $('.players').empty()
  players.forEach(player => {
    $('.players').append(`<li>${player.id} : ${player.username}</li>`)
  })
}
function updateStateName(stateName) {
  $('.state-name').text(stateName)
}

let socket = new Socket("/socket", {
  params: { token: window.userToken }
})
socket.connect()

let channel = socket.channel('battles:1', {})

channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)

    updateStateName(resp.state_name)
    updatePlayerList(resp.players)
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
  })

channel.on('player:joined', payload => { updatePlayerList(payload.players) })
channel.on('player:left',   payload => { updatePlayerList(payload.players) })

channel.on('state_changed', payload => {
  updateStateName(payload.state)
})

export default socket
