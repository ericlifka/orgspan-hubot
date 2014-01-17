# Description:
#   Run magic drafts through hubot, persists user statistics over time.
#
# Commands:
#   hubot room - show the current room, for testing purposes.

module.exports = (robot) ->
	robot.respond /room$/i, (msg) ->
		room = msg.envelope.room
		msg.send "#{room}"
