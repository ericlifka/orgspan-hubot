# Description:
#   Make fun of other people.
#
# Commands:
#   hubot mock <person> - make fun of the specified person

module.exports = (robot) ->
	robot.respond /room$/i, (msg) ->
		room = msg.envelope.room
		msg.send "#{room}"
