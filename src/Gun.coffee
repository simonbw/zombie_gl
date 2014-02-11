



class window.Gun
	constructor: ->
		@cooldown = 0
		@fullauto = true

	update: ->
		if @cooldown > 0
			@cooldown -= 1.0

	fire: (game, x, y, z, dx, dy, vx, vy) ->
		if @cooldown <= 0
			@cooldown = 5.0
			game.addEntity(new MuzzleFlash(x, y, z, dx, dy, vx, vy))
			game.addEntity(new Bullet(x + dx * 0.051, y + dy * 0.051, z, dx, dy, vx, vy))
			game.soundManager.playSound("pistol_shot")