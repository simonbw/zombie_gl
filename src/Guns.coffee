class FiveSeven extends Gun
    constructor: ->
        super("pistol", false, 1000, 20, 0.95, 35, 50, 100)

class P90 extends Gun
    constructor: ->
        super("pistol", true, 900, 50, 1.2, 25, 100, 40)

class AR15 extends Gun
    constructor: ->
        super("rifle", false, 700, 30, 1.5, 50, 300, 20)

class M4 extends Gun
    constructor: ->
        super("rifle", true, 700, 30, 1.75, 50, 200, 24)

window.guns = {
    'FiveSeven': FiveSeven,
    'P90': P90,
    'AR15': AR15,
    'M4': M4,
}
