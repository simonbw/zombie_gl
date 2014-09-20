class window.Sector
    @SIZE: 70

    constructor: (@x, @y) ->
        @entities = []
        @loaded = false

    load: (game) ->
        if @loaded
            console.log "already loaded"
        @loaded = true
        console.log "loading sector at", @x, @y
        worldX = @x * Sector.SIZE
        worldY = @y * Sector.SIZE
        game.addEntity(new Ground(worldX, worldY, Sector.SIZE, Sector.SIZE))
        for i in [0..4]
            for j in [0..4]
                game.addEntity(new Building(worldX + 6 + 12 * i, worldY + 6 + 12 * j))
        for i in [0..3]
            for j in [0..3]
                game.addEntity(new ZombieSpawner(worldX + 6 + 12 * i + 11, worldY + 6 + 12 * j + 11, 0.1))

        game.addEntity(new StreetLight(worldX, worldY))
        game.addEntity(new StreetLight(worldX, worldY + 35))
        game.addEntity(new StreetLight(worldX + 35, worldY))
        game.addEntity(new StreetLight(worldX + 35, worldY + 35))

    unload: (game) ->
        if not @loaded
            console.log ""
        @loaded = false
        console.log "unloading sector at", @x, @y
        for entity in @entities
            game.removeEntity(entity)