# Settings
MOVE_THRESHOLD = 0.15
LOOK_THRESHOLD = 0.2
BUTTON_THRESHOLD = 0.4

# Keyboard Constants
K_UP = 87				# W
K_DOWN = 83				# S
K_LEFT = 65				# A
K_RIGHT = 68			# D
K_FLASHLIGHT = 70		# F
K_RELOAD = 82			# R
K_GAMEPAD_TOGGLE = 71	# G
K_ZOOM_IN = 90			# Z
K_ZOOM_OUT = 88			# X
K_RESET = 191			# /

# Button Constants
B_FLASHLIGHT = 3		# Y
B_RELOAD = 2			# X
B_RTRIGGER = 7

class window.IO
	constructor: (game) ->
		@moveX = 0
		@moveY = 0
		@lookDirection = 0
		@flashlight = true
		@trigger = false
		@zoom = 0
		@triggerPressed = false
		@reloadPressed = false
		@gamepad = null
		@gamepadEnabled = false
		@keys = []
		@mouseButtons = []
		@mousePosition = {x: 0, y:0}

		@buttons = []
		@axes = []

		@buttonPressedCallbacks = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
		@buttonReleasedCallbacks = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]

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
					when K_RESET
						game.start()

			@keys[event.keyCode] = true

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

			if Math.sqrt(lookX * lookX + lookY * lookY) > LOOK_THRESHOLD
				@lookDirection = Math.atan2(lookY, lookX)

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
			lookX = @mousePosition.x - window.innerWidth / 2
			lookY = -(@mousePosition.y - window.innerHeight / 2)
			if Math.sqrt(lookX * lookX + lookY * lookY) > LOOK_THRESHOLD
				@lookDirection = Math.atan2(lookY, lookX)
			# Camera Controls
			if @keys[K_ZOOM_IN]
				@zoom = Math.min(@zoom + 0.08, 1.0)
			if @keys[K_ZOOM_OUT]
				@zoom = Math.max(@zoom - 0.08, -1.0)
			if !@keys[K_ZOOM_IN] && !@keys[K_ZOOM_OUT]
				@zoom = 0.85 * @zoom

	update2: (game) ->
		@triggerPressed = false
		@reloadPressed = false