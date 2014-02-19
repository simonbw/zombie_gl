class window.Gun
	constructor: (@soundName, @fullauto, @firerate, @clipSize, @reloadTime, @damage, @accuracy, @recoil)->
		@cooldown = 0
		@ammo = @clipSize
		@reloading = false
		@reloadTime2 = 0.22

		@reloadSound = "#{@soundName}_reload"
		@reloadFinishSound = "#{@soundName}_reload_finish"
		@emptySound = "gun_empty"

	update: (game) ->
		if @cooldown > 0
			@cooldown -= 1 / 60
		if @reloading
			if @cooldown <= 0
				@reloadFinish(game)

	reload: (game) ->
		if (!@reloading && @cooldown <= 1.0 && @ammo < @clipSize)
			@reloading = true
			@cooldown = @reloadTime
			game.soundManager.playSound(@reloadSound)

	reloadFinish: (game) ->
		@reloading = false
		@ammo = @clipSize
		@cooldown = @reloadTime2
		game.soundManager.playSound(@reloadFinishSound)

	pullTrigger: (game, firstPress, x, y, z, dx, dy, vx, vy) ->
		if firstPress || @fullauto
			if @cooldown <= 0 && @ammo > 0
				@ammo -= 1
				@cooldown += 60.0 / @firerate
				game.soundManager.playSound("#{@soundName}_shot")
				flash = new MuzzleFlash(x, y, z, dx, dy, vx, vy)
				game.addEntity(flash)
				
				direction = Math.atan2(dy, dx) + Random.normal(0.1 / @accuracy)
				dx = Math.cos(direction)
				dy = Math.sin(direction)
				bullet = new Bullet(x + dx * 0.051, y + dy * 0.051, z, dx, dy, vx, vy, @damage)
				game.addEntity(bullet)
				return Random.normal(@recoil)
			else if firstPress && @ammo == 0
				game.soundManager.playSound(@emptySound)
		return 0
