
class window.ZombieSpawner
	constructor: (@x, @y, @chance = 1.0) ->
		console.log "new zombie spawner #{@chance}"

	update: (game) ->
		if (Random.bool(@chance / 60))
			console.log "spawning zombie"
			zombie = new Zombie(@x, @y)
			game.addEntity(zombie)