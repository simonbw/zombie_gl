# Settings
MOVE_THRESHOLD = 0.15
LOOK_THRESHOLD = 0.2
BUTTON_THRESHOLD = 0.4

# Keyboard Constants
K_UP = 87 # W
K_DOWN = 83 # S
K_LEFT = 65 # A
K_RIGHT = 68 # D
K_FLASHLIGHT = 70 # F
K_RELOAD = 82 # R
K_NEXT_GUN = 81 # Q
K_ZOOM_IN = 90 # Z
K_ZOOM_OUT = 88 # X

K_GAMEPAD_TOGGLE = 71 # G
K_RESET = 191 # /
K_FULLSCREEN = 190 # .

# Button Constants
B_FLASHLIGHT = 3 # Y
B_RELOAD = 2 # X
B_NEXT_GUN = 1 # B
B_LTRIGGER = 6 # Left Trigger
B_RTRIGGER = 7 # Right Trigger
B_ZOOM_IN = 12 # D-Up
B_ZOOM_OUT = 13 # D-Down Trigger

class window.IO
    constructor: (game) ->
        @moveX = 0
        @moveY = 0
        @lookDirection = 0
        @lookDistance = 1.0
        @flashlight = true
        @trigger = false
        @zoom = 0
        @triggerPressed = false
        @reloadPressed = false
        @nextGunPressed = false
        @gamepad = null
        @gamepadEnabled = false
        @keys = []
        @mouseButtons = []
        @mousePosition = {x: 0, y: 0}

        @buttons = []
        @axes = []

        @buttonPressedCallbacks = [
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            []
        ]
        @buttonReleasedCallbacks = [
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            [],
            []
        ]

        window.addEventListener "keydown", (event) =>
            if !@keys[event.keyCode]
                switch event.keyCode
                when K_FLASHLIGHT
                    if !@gamepad || !@gamepadEnabled
                        @flashlight = !@flashlight
                when K_GAMEPAD_TOGGLE
                    @gamepadEnabled = !@gamepadEnabled
                when K_RELOAD
                    if !@gamepad || !@gamepadEnabled
                        @reloadPressed = true
                when K_NEXT_GUN
                    if !@gamepad || !@gamepadEnabled
                        @nextGunPressed = true
                when K_RESET
                    game.start()
                when K_FULLSCREEN
                    if document.fullScreen || document.webkitIsFullScreen || document.mozfullScreen
                        if document.cancelFullScreen
                            document.cancelFullScreen()
                        else if document.webkitCancelFullScreen
                            document.webkitCancelFullScreen()
                        else if document.mozCancelFullScreen
                            document.mozCancelFullScreen()
                    else
                        e = game.renderer.domElement
                        if (e.requestFullScreen)
                            e.requestFullScreen()
                        else if (e.webkitRequestFullScreen)
                            e.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT)
                        else if (e.mozRequestFullScreen)
                            e.mozRequestFullScreen()

            @keys[event.keyCode] = true

        window.oncontextmenu = (event) ->
            event.preventDefault();
            event.stopPropagation();
            return false;

        window.addEventListener "keyup", (event) =>
            @keys[event.keyCode] = false

        window.addEventListener "mousedown", (event) =>
            if event.button = 1
                @triggerPressed = true
            @mouseButtons[event.button] = true

        window.addEventListener "mouseup", (event) =>
            @mouseButtons[event.button] = false

        window.addEventListener "mousemove", (event) =>
            @mousePosition.x = event.clientX
            @mousePosition.y = event.clientY

        @buttonPressedCallbacks[B_FLASHLIGHT].push =>
            @flashlight = !@flashlight

        @buttonPressedCallbacks[B_RTRIGGER].push =>
            @triggerPressed = true

        @buttonPressedCallbacks[B_RELOAD].push =>
            @reloadPressed = true

        @buttonPressedCallbacks[B_NEXT_GUN].push =>
            @nextGunPressed = true

    update: =>
        @moveX = 0
        @moveY = 0

        lastGamepad = @gamepad
        @gamepad = navigator.webkitGetGamepads()[0]
        # Enable gamepad when plugged in
        if @gamepad && !lastGamepad
            @gamepadEnabled = true

        if @gamepadEnabled && @gamepad
            # disable cursor
            $("body").css("cursor", "none")

            # Register button presses
            for i in [0...15]
                if (@gamepad.buttons[i] > BUTTON_THRESHOLD) && (@buttons[i] < BUTTON_THRESHOLD)
                    for f in @buttonPressedCallbacks[i]
                        f()
                if (@gamepad.buttons[i] < BUTTON_THRESHOLD) && (@buttons[i] > BUTTON_THRESHOLD)
                    for f in @buttonReleasedCallbacks[i]
                        f()
                @buttons[i] = @gamepad.buttons[i]

            @moveX = if Math.abs(@gamepad.axes[0]) >= MOVE_THRESHOLD then @gamepad.axes[0] else 0
            @moveY = if Math.abs(@gamepad.axes[1]) >= MOVE_THRESHOLD then -@gamepad.axes[1] else 0
            lookX = @gamepad.axes[2]
            lookY = -@gamepad.axes[3]
            @trigger = @gamepad.buttons[B_RTRIGGER] > BUTTON_THRESHOLD

            @lookDistance = Math.sqrt(lookX * lookX + lookY * lookY)
            if @lookDistance > LOOK_THRESHOLD
                @lookDirection = Math.atan2(lookY, lookX)

            if @gamepad.buttons[B_ZOOM_IN]
                @zoom = Math.min(@zoom + 0.08, 1.0)
            if @gamepad.buttons[B_ZOOM_OUT]
                @zoom = Math.max(@zoom - 0.08, -1.0)
            if !@gamepad.buttons[B_ZOOM_IN] && !@gamepad.buttons[B_ZOOM_OUT]
                @zoom = 0.85 * @zoom

        else
            # enable cursor
            $("body").css("cursor", "crosshair")

            # keybaord controls
            if @keys[K_UP] && !@keys[K_DOWN]
                @moveY = 1.0
            if @keys[K_DOWN] && !@keys[K_UP]
                @moveY = -1.0
            if @keys[K_LEFT] && !@keys[K_RIGHT]
                @moveX = -1.0
            if @keys[K_RIGHT ] && !@keys[K_LEFT]
                @moveX = 1.0
            # mouse controls
            @trigger = !!@mouseButtons[0]

            # TODO: Fix mouse angle stuff
            lookX = (@mousePosition.x - window.innerWidth / 2)
            lookY = -(@mousePosition.y - window.innerHeight / 2)
            @lookDistance = Math.sqrt(lookX * lookX + lookY * lookY)
            @lookDirection = Math.atan2(lookY, lookX)
            # Camera Controls
            if @keys[K_ZOOM_IN]
                @zoom = Math.min(@zoom + 0.08, 1.0)
            if @keys[K_ZOOM_OUT]
                @zoom = Math.max(@zoom - 0.08, -1.0)
            if !@keys[K_ZOOM_IN] && !@keys[K_ZOOM_OUT]
                @zoom = 0.85 * @zoom

    postUpdate: (game) ->
        @triggerPressed = false
        @reloadPressed = false
        @nextGunPressed = false
