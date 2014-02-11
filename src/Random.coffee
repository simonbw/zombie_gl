



class window.Random
	@bool: (chance = 0.5) ->
		return Math.random() < chance

	@normal: (variance = 1.0, mean = 0.0) ->
		return (Math.random() + Math.random() + Math.random() - 1.5) * variance + mean

	@int: (min, max) ->
		return Math.floor(Math.random() * (max - min) + max)

	@uniform: (min, max) -> 
		return Math.random() * (max - min) + max