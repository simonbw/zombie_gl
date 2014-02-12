# Constants


class window.ShadowTest
	constructor: () ->
		console.log("Created New ShadowTest")

	start: =>
		console.log("Starting Game")
		@io = new IO()

		# @renderer = new THREE.WebGLRenderer({antialias:true})
		# @renderer = new THREE.WebGLDeferredRenderer({ width: window.innerWidth, height: window.innerHeight, scale: 1, antialias: true, tonemapping: THREE.UnchartedOperator, brightness: 2.5 });
		@renderer = new THREE.WebGLDeferredRenderer({ width: window.innerWidth, height: window.innerHeight, scale: 1, antialias: true, brightness: 1.0 })
		window.document.body.appendChild(@renderer.domElement)

		@scene = new THREE.Scene()
		@camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 20000)
		@scene.add(@camera)
		@camera.position.set(0, -200, 400)
		@camera.lookAt({x:0, y:0, z:0})
		
		window.addEventListener 'resize', =>
			@renderer.setSize window.innerWidth, window.innerHeight
			@camera.aspect = window.innerWidth / window.innerHeight
			@camera.updateProjectionMatrix()
		

		# @scene.add(new THREE.AmbientLight(0x010101))

		# ================================ #
		# ----------- LIGHTING ----------- #
		# ================================ #
		@renderer.shadowMapEnabled = true
		# @renderer.shadowCameraNear = 3;
		# @renderer.shadowCameraFar = @camera.far;
		# @renderer.shadowCameraFov = 45;
		# @renderer.shadowMapBias = 0.0039;
		# @renderer.shadowMapDarkness = 0.5;
		@renderer.shadowMapWidth = 1024;
		@renderer.shadowMapHeight = 1024;
		
		sun = new THREE.SpotLight(0xFFFFFF)
		sun.position.set(500, 500, 1000)
		sun.castShadows = true
		sun.castShadow = true;
		sun.shadowMapWidth = 1024;
		sun.shadowMapHeight = 1024;
		sun.shadowCameraNear = 500;
		sun.shadowCameraFar = 4000;
		sun.shadowCameraFov = 30;
		# sun.shadowCameraVisible = true
		# sun.shadowDarkness = 0.2;
		@scene.add(sun)

		# spotLight = new THREE.DirectionalLight( 0xffffff );
		# spotLight.position.set( 100, 1000, 100 );
		# spotLight.castShadow = true;
		# spotLight.shadowMapWidth = 1024;
		# spotLight.shadowMapHeight = 1024;
		# spotLight.shadowCameraNear = 500;
		# spotLight.shadowCameraFar = 4000;
		# spotLight.shadowCameraFov = 30;
		# @scene.add(spotLight);

		ground = new THREE.Mesh(new THREE.PlaneGeometry(256+128, 256, 1, 1), new THREE.MeshPhongMaterial({color: 0x22FF00}))
		ground.receiveShadow = true
		@scene.add(ground)

		box = new THREE.Mesh(new THREE.CubeGeometry(64, 64, 64), new THREE.MeshPhongMaterial({color:0xFF0000}))
		box.castShadow = true
		box.position.set(0, 0, 32)
		@scene.add(box)

		console.log("Game Started Successfully")
		@update()

	update: () =>
		window.requestAnimationFrame(@update)
		@render()

	render: () =>
		@renderer.render(@scene, @camera)
