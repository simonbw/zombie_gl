



class window.Stats
	constructor: ->
		@kills = 0
		@totalKills = 0		# load from disk
		@mostKills = 0		# load from disk
		@gamesPlayed = 0	# load from disk

	addKill: ->
		@kills++
		@totalKills++

	newGame: ->
		@gamesPlayed++
		console.log "#{@gamesPlayed} games played. #{@kills} zombies killed this round. #{@totalKills} total zombies killed."
		@mostKills = Math.max(@kills, @mostKills)
		@kills = 0

	save: ->
		# write to disk
