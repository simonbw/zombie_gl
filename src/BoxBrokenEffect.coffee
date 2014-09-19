GRAVITY = 9.8 / (60)
AIR_DRAG = 0.999
AIR_ANGULAR_DRAG = 0.995
GROUND_DRAG = 0.95
GROUND_ANGULAR_DRAG = 0.94
LIFESPAN = 150
EXPLOSION_FORCE = 0.8
ROTATION_ACCEL = 0.005
OFFSET = 7.765

TOP = 0
BOTTOM = 1
LEFT = 2
RIGHT = 3
FRONT = 4
BACK = 5

SIZE = Box.SIZE


class window.BoxBrokenEffect

    @material = new THREE.MeshPhongMaterial {
    # color: 0x77664B,
        side: THREE.DoubleSide,
        map: Box.texture,
        bumpMap: Box.bumpMap,
        bumpScale: 0.02
    }

    constructor: (@x, @y, @angle) ->
        @lifespan = LIFESPAN
        @meshes = []
        @velocities = []
        @offsets = []
        @spins = []

        @meshContainer = new THREE.Object3D()
        @meshContainer.position.set(@x, @y, SIZE / 2 + 0.001)
        @meshContainer.rotation.z = @angle
        for i in [TOP, BOTTOM, LEFT, RIGHT, FRONT, BACK]
            geometry = new THREE.PlaneGeometry(SIZE, SIZE)
            mesh = new THREE.Mesh(geometry, BoxBrokenEffect.material)
            @meshes.push(mesh)
            @meshContainer.add(mesh)
            @velocities.push(new THREE.Vector3())
            @spins.push(new THREE.Vector3())
            @offsets.push(new THREE.Vector3())

        # top
        @meshes[TOP].position.z = SIZE / 2

        @velocities[TOP].x = Random.normal(1.0)
        @velocities[TOP].y = Random.normal(1.0)
        @velocities[TOP].z = (Math.random() + 0.1) * EXPLOSION_FORCE
        @spins[TOP].z = Random.normal(0.05)

        # bottom
        @meshes[BOTTOM].position.z = -SIZE / 2
        @spins[BOTTOM].z = Random.normal(0.03)

        # right
        @meshes[RIGHT].position.x = SIZE / 2
        @meshes[RIGHT].rotation.y = -Math.PI / 2
        @spins[RIGHT].y = 0.02
        @velocities[RIGHT].x = EXPLOSION_FORCE * (Math.random() + 0.1)
        @spins[RIGHT].z = Random.normal(0.03)

        # left
        @meshes[LEFT].position.x = -SIZE / 2
        @meshes[LEFT].rotation.y = Math.PI / 2
        @spins[LEFT].y = -0.02
        @velocities[LEFT].x = -EXPLOSION_FORCE * (Math.random() + 0.1)
        @spins[LEFT].z = Random.normal(0.03)

        # front
        @meshes[FRONT].position.y = SIZE / 2
        @meshes[FRONT].rotation.x = Math.PI / 2
        @spins[FRONT].x = -0.02
        @velocities[FRONT].y = EXPLOSION_FORCE * (Math.random() + 0.1)
        @spins[FRONT].z = Random.normal(0.03)

        # back
        @meshes[BACK].position.y = -SIZE / 2
        @meshes[BACK].rotation.x = -Math.PI / 2
        @spins[BACK].x = 0.02
        @velocities[BACK].y = -EXPLOSION_FORCE * (Math.random() + 0.1)
        @spins[BACK].z = Random.normal(0.03)


    init: (game) =>
        game.scene.add(@meshContainer)

    update: (game) =>
        # Bottom
        @velocities[BOTTOM].multiplyScalar(GROUND_DRAG)
        @spins[BOTTOM].z *= GROUND_ANGULAR_DRAG

        # Top
        if @meshes[TOP].position.z > -SIZE / 2
            @velocities[TOP].z -= GRAVITY
            @velocities[TOP].x *= AIR_DRAG
            @velocities[TOP].y *= AIR_DRAG
            @spins[TOP].z *= AIR_ANGULAR_DRAG
        else
            @velocities[TOP].z = 0
            @velocities[TOP].x *= GROUND_DRAG
            @velocities[TOP].y *= GROUND_DRAG
            @meshes[TOP].position.z = -SIZE / 2
            @spins[TOP].z *= GROUND_ANGULAR_DRAG

        # Left
        if @meshes[LEFT].rotation.y > 0
            @spins[LEFT].y += Math.sign(@spins[LEFT].y) * ROTATION_ACCEL
        else
            @spins[LEFT].y = 0
            @meshes[LEFT].rotation.y = 0
        grounded = 1 - Math.abs(@meshes[LEFT].rotation.y / (Math.PI / 2))
        @spins[LEFT].multiplyScalar(AIR_ANGULAR_DRAG * (1 - grounded) + GROUND_ANGULAR_DRAG * grounded)
        @velocities[LEFT].multiplyScalar(AIR_DRAG * (1 - grounded) + GROUND_DRAG * grounded)
        fallen = Math.abs(Math.sin(@meshes[LEFT].rotation.y) * SIZE / 2)
        @meshes[LEFT].position.z = fallen * SIZE / 2 - SIZE / 2
        @offsets[LEFT].x = -fallen * SIZE / 2 / OFFSET

        # right
        if @meshes[RIGHT].rotation.y < 0
            @spins[RIGHT].y += Math.sign(@spins[RIGHT].y) * ROTATION_ACCEL
        else
            @spins[RIGHT].y = 0
            @meshes[RIGHT].rotation.y = 0
        grounded = 1 - Math.abs(@meshes[RIGHT].rotation.y / (Math.PI / 2))
        @spins[RIGHT].multiplyScalar(AIR_ANGULAR_DRAG * (1 - grounded) + GROUND_ANGULAR_DRAG * grounded)
        @velocities[RIGHT].multiplyScalar(AIR_DRAG * (1 - grounded) + GROUND_DRAG * grounded)
        fallen = Math.abs(Math.sin(@meshes[RIGHT].rotation.y) * SIZE / 2)
        @meshes[RIGHT].position.z = fallen * SIZE / 2 - SIZE / 2
        @offsets[RIGHT].x = fallen * SIZE / 2 / OFFSET

        # front
        if @meshes[FRONT].rotation.x > 0
            @spins[FRONT].x += Math.sign(@spins[FRONT].x) * ROTATION_ACCEL
        else
            @spins[FRONT].x = 0
            @meshes[FRONT].rotation.x = 0
        grounded = 1 - Math.abs(@meshes[FRONT].rotation.x / (Math.PI / 2))
        @spins[FRONT].multiplyScalar(AIR_ANGULAR_DRAG * (1 - grounded) + GROUND_ANGULAR_DRAG * grounded)
        @velocities[FRONT].multiplyScalar(AIR_DRAG * (1 - grounded) + GROUND_DRAG * grounded)
        fallen = Math.abs(Math.sin(@meshes[FRONT].rotation.x) * SIZE / 2)
        @meshes[FRONT].position.z = fallen * SIZE / 2 - SIZE / 2
        @offsets[FRONT].y = fallen * SIZE / 2 / OFFSET

        # back
        if @meshes[BACK].rotation.x < 0
            @spins[BACK].x += Math.sign(@spins[BACK].x) * ROTATION_ACCEL
        else
            @spins[BACK].x = 0
            @meshes[BACK].rotation.x = 0
        grounded = 1 - Math.abs(@meshes[BACK].rotation.x / (Math.PI / 2))
        @spins[BACK].multiplyScalar(AIR_ANGULAR_DRAG * (1 - grounded) + GROUND_ANGULAR_DRAG * grounded)
        @velocities[BACK].multiplyScalar(AIR_DRAG * (1 - grounded) + GROUND_DRAG * grounded)
        fallen = Math.abs(Math.sin(@meshes[BACK].rotation.x) * SIZE / 2)
        @meshes[BACK].position.z = fallen * SIZE / 2 - SIZE / 2
        @offsets[BACK].y = -fallen * SIZE / 2 / OFFSET

        # update all
        for i in [0...@meshes.length]
            mesh = @meshes[i]
            mesh.position.x += @velocities[i].x / 60
            mesh.position.y += @velocities[i].y / 60
            mesh.position.z += @velocities[i].z / 60
            mesh.position.x += @offsets[i].x
            mesh.position.y += @offsets[i].y
            mesh.position.z += @offsets[i].z
            mesh.rotation.x += @spins[i].x
            mesh.rotation.y += @spins[i].y
            mesh.rotation.z += @spins[i].z

    # @lifespan--
    # if @lifespan <= 0
    # 	game.removeEntity(this)

    dispose: (game) =>
        if @disposed
            console.log "removing HitEffect twice"
        @disposed = true
        game.scene.remove(@meshContainer)
