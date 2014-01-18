# Description:
#   Run magic drafts through hubot, persists user statistics over time.
#
# Commands:
#   hubot new draft - Start a draft
#	hubot end draft - End the current draft and output final match statistics
#	hubot draft status - Display information about the current draft

magicRoom = "528f6fc86efdfa5420b8c1fd@conference.orgspan.com"

isMagicRoom = (msg) ->
	room = msg.envelope.room
	room is magicRoom or room is 'Shell'

newDraft = (robot, msg) ->
	if robot.brain.get 'currentMagicDraft'
		msg.send "Current draft hasn't ended, use 'hubot end draft' to finish the current draft."
	else
		robot.brain.set 'currentMagicDraft', {
			players: []
			results: []
			decks: []
			date: new Date().toISOString()
		}

		msg.send "New Draft created and ready for entrants."

endDraft = (robot, msg) ->
	outputDraftStatistics robot, msg

	if not robot.brain.get 'currentMagicDraft'
		msg.send "There is no draft running."
	else
		currentDraft = robot.brain.get 'currentMagicDraft'
		previousDrafts = robot.brain.get('previousMagicDrafts') or []
		previousDrafts.push currentDraft

		robot.brain.set 'previousMagicDrafts', previousDrafts
		robot.brain.set 'currentMagicDraft', null

outputDraftStatistics = (robot, msg) ->
	console.log robot.brain.get 'currentMagicDraft'
	console.log robot.brain.get 'previousMagicDrafts'

module.exports = (robot) ->
	robot.respond /new draft$/i, (msg) ->
		if isMagicRoom msg
			newDraft robot, msg

	robot.respond /end draft$/i, (msg) ->
		if isMagicRoom msg
			endDraft robot, msg		

	robot.respond /draft status$/i, (msg) ->
		if isMagicRoom msg
			outputDraftStatistics robot, msg
