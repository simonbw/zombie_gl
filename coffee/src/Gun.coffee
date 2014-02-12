class window.Gun
	constructor: (@soundName, @fullauto, @firerate, @clipSize, @reloadTime)->
		@cooldown = 0
		@ammo = @clipSize

	update: (game) ->
		if @cooldown > 0
			@cooldown -= 1 / 60

	reload: (game) ->
		if (@cooldown <= 1.0)
			@cooldown = @reloadTime
			@ammo = @clipSize
			game.soundManager.playSound("#{@soundName}_reload")

	pullTrigger: (game, firstPress, x, y, z, dx, dy, vx, vy) ->
		if firstPress || @fullauto
			if @cooldown <= 0 && @ammo > 0
				@ammo -= 1
				@cooldown += 60.0 / @firerate
				flash = new MuzzleFlash(x, y, z, dx, dy, vx, vy)
				game.addEntity(flash)
				bullet = new Bullet(x + dx * 0.051, y + dy * 0.051, z, dx, dy, vx, vy)
				game.addEntity(bullet)
				game.soundManager.playSound("#{@soundName}_shot")
			else if firstPress && @ammo == 0
				game.soundManager.playSound("#{@soundName}_empty")
