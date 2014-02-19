

class FiveSeven extends Gun
	constructor: ->
		super("pistol", false, 1000, 20, 0.95 , 35, 10)

class P90 extends Gun
	constructor: ->
		super("pistol", true, 700, 50, 1.2, 25, 10)

class AR15 extends Gun
	constructor: ->
		super("rifle", false, 700, 30, 1.5, 35, 30)

class M4 extends Gun
	constructor: ->
		super("rifle", true, 700, 30, 1.75, 35, 25)

window.guns = {
	'FiveSeven': FiveSeven,
	'P90': P90,
	'AR15': AR15,
	'M4': M4,
}
