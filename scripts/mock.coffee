# Description:
#   Make fun of other people.
#
# Commands:
#   hubot mock <person> - make fun of the specified person

module.exports = (robot) ->
	robot.respond /mock (.*)$/i, (msg) ->
		person = msg.match[1] or ""
		msg.send "@#{person} your mother was a hamster and your father smelt of elderberries!"
