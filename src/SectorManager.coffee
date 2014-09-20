UNLOAD_DISTANCE = 5

class window.SectorManager
    constructor: (@game) ->
        @sectors = {}
        @postUpdate(@game)

    postUpdate: (game) ->
        centerX = Math.floor game.player.x / Sector.SIZE
        centerY = Math.floor game.player.y / Sector.SIZE
        @loadNear(game, centerX, centerY)
        @unloadFar(game, centerX, centerY)

    loadNear: (game, centerX, centerY) ->
        for i in [0..9]
            x2 = centerX - 1 + i % 3;
            y2 = centerY - 1 + Math.floor(i / 3)
            @loadSector(x2, y2)

    unloadFar: (game, centerX, centerY) ->
        for xy, sector of @sectors
            [x3, y3] = xy.split ','
            if sector.loaded and Math.abs(x3 - centerX) + Math.abs(y3 - centerY) > UNLOAD_DISTANCE
                @unloadSector(sector)

    makeKey: (x, y) ->
        return x + ',' + y

    hasSector: (x, y) ->
        return @makeKey(x, y) of @sectors

    getSector: (x, y) ->
        unless @hasSector(x, y)
            @setSector(x, y, new Sector(x, y))
        return @sectors[@makeKey(x, y)]

    setSector: (x, y, sector) ->
        @sectors[@makeKey(x, y)] = sector

    loadSector: (x, y) ->
        sector = @getSector(x, y)
        if not sector.loaded
            sector.load(@game)

    unloadSector: (x, y) ->
        @getSector(x, y).unload(@game);