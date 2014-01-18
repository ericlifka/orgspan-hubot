# Description:
#   Run magic drafts through hubot, persists user statistics over time.
#
# Commands:
#   hubot draft new - Start a magic draft
#	hubot draft end - End the current magic draft and output final match statistics
#	hubot draft status - Display information about the current magic draft
#	hubot draft signup user colors keywords... - Colors [BUWGRbuwgr], Keywords [aggro, control, ... etc], ex: 'signup Eric GW aggro angels'
#	hubot draft list players all - All players who have participated in any drafts
#	hubot draft list players current - Players participating in the current draft
#	hubot draft report result <user> vs <user> <result> - result can be #-# or #-#-#, ex: 2-1 or 0-1-1

module.exports = (robot) ->
	magicRoom = "528f6fc86efdfa5420b8c1fd@conference.orgspan.com"

	isMagicRoom = (msg) ->
		room = msg.envelope.room
		room is magicRoom or room is 'Shell'

	getMagicPlayers = (user) ->
		robot.brain.get('magicPlayers') or {}

	saveMagicPlayers = (players) ->
		robot.brain.set 'magicPlayers', players

	getCurrentDraft = () ->
		draft = robot.brain.get 'currentMagicDraft'
		if not draft
			msg.send "There is no draft running."
			false
		else
			draft

	newDraft = (msg) ->
		if robot.brain.get 'currentMagicDraft'
			msg.send "Current draft hasn't ended, use 'hubot end draft' to finish the current draft."
		else
			robot.brain.set 'currentMagicDraft', {
				players: []
				results: []
				date: new Date().toISOString()
			}

			msg.send "New Draft created and ready for entrants."

	endDraft = (msg) ->
		if currentDraft = getCurrentDraft()
			msg.send "Draft wrapup:"
			outputDraftStatistics msg

			previousDrafts = robot.brain.get('previousMagicDrafts') or []
			previousDrafts.push currentDraft

			robot.brain.set 'previousMagicDrafts', previousDrafts
			robot.brain.set 'currentMagicDraft', null

	outputDraftStatistics = (msg) ->
		console.log robot.brain.get 'currentMagicDraft'
		console.log robot.brain.get 'previousMagicDrafts'

	signupUser = (msg) ->
		if currentDraft = getCurrentDraft()
			user = msg.match[1]
			colors = msg.match[2]
			tags = (tag for tag in msg.match[3].split(' ') when tag)

			currentDraft.players.push {user, colors, tags}
			robot.brain.set 'currentMagicDraft', currentDraft

			players = getMagicPlayers()
			if not players[user]
				players[user] = {
					decks: []
					drafts: 0
					wins: 0
					losses: 0
					ties: 0
				}
				saveMagicPlayers players

	listAllPlayers = (msg) ->
		msg.send(name) for name, description of getMagicPlayers()

	listCurrentPlayers = (msg) ->
		if currentDraft = getCurrentDraft()
			msg.send(player.user) for player in currentDraft.players

	reportResult = (msg) ->
		if currentDraft = getCurrentDraft()
			user1 = msg.match[1]
			user2 = msg.match[2]
			wins = msg.match[3]
			losses = msg.match[4]
			ties = msg.match[5] or 0
			#calculate and record results

	robot.respond /draft new$/i, (msg) ->
		if isMagicRoom msg
			newDraft msg

	robot.respond /draft end$/i, (msg) ->
		if isMagicRoom msg
			endDraft msg		

	robot.respond /draft status$/i, (msg) ->
		if isMagicRoom msg
			outputDraftStatistics msg

	robot.respond /draft signup (\w+) ([BUWGRbuwgr]+) ?(.*)$/i, (msg) ->
		if isMagicRoom msg
			signupUser msg

	robot.respond /draft list all players$/i, (msg) ->
		if isMagicRoom msg
			listAllPlayers msg

	robot.respond /draft list current players$/i, (msg) ->
		if isMagicRoom msg
			listCurrentPlayers msg

	robot.respond /draft report result (\w+) vs (\w+) (\d)-(\d)-?(\d?)$/i, (msg) ->
		if isMagicRoom msg
			reportResult msg
