

class window.Pistol extends Gun
	constructor: ->
		super("pistol", false, 1000, 20, 1.8)

class window.SMG extends Gun
	constructor: ->
		super("pistol", true, 700, 50, 2.0)
