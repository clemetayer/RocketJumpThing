# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the player

##### VARIABLES #####
const player_path = "res://Game/Common/MapElements/Characters/MainCharacters/player.tscn"
var player: Player


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = player_path
	.before()


func before_test():
	player = load(player_path).instance()


func after_test():
	player.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_add_velocity_vector() -> void:
	player.add_velocity_vector(Vector3.ONE)
	assert_array(player._add_velocity_vector_queue).is_equal([Vector3.ONE])


func test_override_velocity_vector() -> void:
	player.override_velocity_vector(Vector3.ONE)
	assert_vector3(player._override_velocity_vector).is_equal(Vector3.ONE)


func test_toggle_ability() -> void:
	player.SLIDE_ENABLED = false
	player.ROCKETS_ENABLED = false
	player.toggle_ability("slide", true)
	assert_bool(player.SLIDE_ENABLED).is_true()
	player.toggle_ability("rockets", true)
	assert_bool(player.ROCKETS_ENABLED).is_true()


func test_process_collision() -> void:
	player._process_collision()
	assert_bool(player.get_node("PlayerCollision").disabled).is_false()
	assert_bool(player.get_node("SlideCollision").disabled).is_true()
	player.states.append("sliding")
	player._process_collision()
	assert_bool(player.get_node("PlayerCollision").disabled).is_true()
	assert_bool(player.get_node("SlideCollision").disabled).is_false()


# TODO : Scene runner and inputs/method calls does not work really well
# func test_process_input() -> void:
# 	var runner := scene_runner(player_path)
# 	runner.simulate_key_press(InputMap.get_action_list("movement_forward")[0].scancode)
# 	runner.invoke("_process_input")
# 	assert_vector2(runner.get_property("input_movement_vector")).is_equal(Vector2(0, 1))


func test_init_rocket() -> void:
	var transform := Transform.looking_at(Vector3.FORWARD, Vector3.UP)
	var rocket = player._init_rocket(transform)
	assert_object(rocket).is_not_null()
	assert_vector3(rocket.START_POS).is_equal(Vector3.ZERO + player.ROCKET_START_OFFSET)
	assert_vector3(rocket.DIRECTION).is_equal(Vector3.FORWARD)
	assert_vector3(rocket.UP_VECTOR).is_equal(Vector3.UP)
	rocket.free()


func test_process_sounds() -> void:
	# init
	var run_sound_pitch = player.get_node(player.PATHS.run_sound.pitch)
	var run_sound_unpitch = player.get_node(player.PATHS.run_sound.unpitch)
	var wall_ride_sound = player.get_node(player.PATHS.wall_ride)
	# tests
	## Run below max speed
	player.current_speed = 100.0
	player._process_sounds()
	assert_bool(run_sound_pitch.playing).is_true()
	assert_bool(run_sound_unpitch.playing).is_true()
	assert_str(str(run_sound_pitch.pitch_scale)).is_equal(
		str(100.0 / (player.SOUND_MAX_SPEED / 3.0))
	)
	assert_str(str(run_sound_unpitch.volume_db)).is_equal(
		str(linear2db(100.0 / (player.SOUND_MAX_SPEED / 2.0)))
	)
	# assert_float(run_sound_pitch.pitch_scale).is_equal(100.0 / (player.SOUND_MAX_SPEED / 3.0))
	# assert_float(run_sound_unpitch.volume_db).is_equal(
	# 	linear2db(100.0 / (player.SOUND_MAX_SPEED / 2.0))
	# ) # Still that weird issue where the result is correct, but still counted as false
	## Run above max speed
	player.current_speed = 800.0
	player._process_sounds()
	assert_bool(run_sound_pitch.playing).is_true()
	assert_bool(run_sound_unpitch.playing).is_true()
	assert_float(run_sound_pitch.pitch_scale).is_equal(4.0)
	assert_float(run_sound_unpitch.volume_db).is_equal(0.0)
	## run stopped
	player.current_speed = 0.0
	player._process_sounds()
	assert_bool(run_sound_pitch.playing).is_false()
	assert_bool(run_sound_unpitch.playing).is_false()
	## wall_ride playing
	player.states.append("wall_riding")
	player._process_sounds()
	assert_bool(wall_ride_sound.playing).is_true()
	## wall_ride stop
	player.states.remove("wall_riding")
	player._process_sounds()
	assert_bool(wall_ride_sound.playing).is_false()


func test_override_velocity() -> void:
	player.vel = Vector3.FORWARD
	player.override_velocity_vector(Vector3.RIGHT)
	player._override_velocity()
	assert_vector3(player.vel).is_equal(Vector3.RIGHT)


func test_find_raycast_from_direction() -> void:
	assert_object(player._find_raycast_from_direction(0)).is_null()
	assert_object(player._find_raycast_from_direction(1)).is_equal(
		player.get_node(player.PATHS.raycasts.left)
	)
	assert_object(player._find_raycast_from_direction(-1)).is_equal(
		player.get_node(player.PATHS.raycasts.right)
	)


func test_init_wall_riding() -> void:
	var rc = mock(RayCast) as RayCast
	do_return(Vector3.RIGHT).on(rc).get_collision_normal()
	do_return(Vector3.ZERO).on(rc).get_collision_point()
	player._init_wall_riding(rc)
	assert_vector3(player.transform.origin).is_equal(Vector3.RIGHT * player.WALL_RIDE_WALL_DISTANCE)


func test_get_wall_fw_vector() -> void:
	var rc = mock(RayCast) as RayCast
	# left raycast
	player._RC_wall_direction = 1
	do_return(Vector3.RIGHT).on(rc).get_collision_normal()
	assert_vector3(player._get_wall_fw_vector(rc)).is_equal(Vector3.FORWARD)
	# right raycast
	player._RC_wall_direction = -1
	do_return(Vector3.LEFT).on(rc).get_collision_normal()
	assert_vector3(player._get_wall_fw_vector(rc)).is_equal(Vector3.FORWARD)


func test_wall_jump() -> void:
	player._RC_wall_direction = -1
	player._wall_jump(Vector3.FORWARD)
	var test_vel = (
		Vector3.FORWARD.rotated(Vector3.UP, player.WALL_JUMP_ANGLE)
		* player.WALL_JUMP_BOOST
	)
	test_vel += Vector3.UP * player.WALL_JUMP_UP_BOOST
	assert_vector3(player.vel).is_equal(test_vel)
	assert_bool(player.get_node(player.PATHS.jump_sound).playing).is_true()


func test_wall_ride() -> void:
	var delta := 0.1
	var rc = mock(RayCast) as RayCast
	player.vel = Vector3.FORWARD * 100.0
	player._RC_wall_direction = 1
	do_return(Vector3.RIGHT).on(rc).get_collision_normal()
	do_return(Vector3.ZERO).on(rc).get_collision_point()
	player._wall_ride(rc, Vector3.FORWARD, delta)
	assert_float(player.vel.length()).is_equal(100.0)
	assert_vector3(player.vel).is_equal(
		(
			Vector3(Vector3.FORWARD.x, player.WALL_RIDE_ASCEND_AMOUNT * 0.1, Vector3.FORWARD.z).normalized()
			* 100.0
		)
	)


func test_keep_wallride_raycasts_perpendicular() -> void:
	var rc = mock(RayCast) as RayCast
	var transform = Transform(Basis(Vector3.ONE), Vector3.RIGHT)
	do_return(Vector3.FORWARD.rotated(Vector3.UP, PI / 4.0)).on(rc).get_collision_normal()  # wall with a 45° angle
	do_return(transform).on(rc).get_global_transform()  # raycast currently aiming at the right direction
	do_return(Vector3.ZERO).on(rc).get_collision_point()
	player._keep_wallride_raycasts_perpendicular(rc)
	assert_vector3(player.get_node(player.PATHS.raycasts.root).rotation).is_equal(
		Vector3(0, PI * 3.0 / 4.0, 0)
	)  # note : since is the "inverse" angle, it is 3/4 of PI


func test_ground_jump() -> void:
	player._ground_jump()
	assert_vector3(player.vel).is_equal(Vector3(0, player.JUMP_POWER, 0))
	assert_bool(player.get_node(player.PATHS.jump_sound).playing).is_true()


func test_apply_friction() -> void:
	# not sliding
	player.vel = Vector3(100.0, 0, 100.0)
	var speed_test = player.vel.length()
	player.current_speed = player.vel.length()
	player._apply_friction(0.1)
	var vel_test = (
		Vector3(100.0, 0, 100.0)
		* (abs(speed_test - (player.GROUND_FRICTION * speed_test * 0.1)) / speed_test)
	)
	assert_vector3(player.vel).is_equal(vel_test)
	# sliding
	player.vel = Vector3(100.0, 0, 100.0)
	speed_test = player.vel.length()
	player.current_speed = player.vel.length()
	player._slide = true
	player._apply_friction(0.1)
	vel_test = (
		Vector3(100.0, 0, 100.0)
		* (abs(speed_test - (player.SLIDE_FRICTION * speed_test * 0.1)) / speed_test)
	)
	assert_vector3(player.vel).is_equal(vel_test)


func test_accelerate() -> void:
	# test do not accelerate
	player.vel = Vector3.FORWARD * 50.0
	player._accelerate(Vector3.FORWARD, 50.0, 5.0, 0.1)
	assert_vector3(player.vel).is_equal(Vector3.FORWARD * 50.0)
	# test accelerate (forward, standard acceleration)
	player.vel = Vector3.FORWARD * 50.0
	player._accelerate(Vector3.FORWARD, 100.0, 5.0, 0.1)
	assert_float(player.vel.length()).is_greater(Vector3.FORWARD.length() * 50.0)
	# test accelerate (strafe)
	player.vel = Vector3.FORWARD * 50.0
	player._accelerate(Vector3.FORWARD.rotated(Vector3.UP, PI / 6.0), 50.0, 5.0, 0.1)
	assert_float(player.vel.length()).is_greater(Vector3.FORWARD.length() * 50.0)


func test_air_movement() -> void:
	# test moving forward, accelerating
	player.dir = Vector3.FORWARD
	player.input_movement_vector = Vector2(0, 1)
	player.current_speed = player.AIR_TARGET_SPEED / 2.0
	player.vel = Vector3.FORWARD * player.current_speed
	player._air_movement(0.1)
	assert_float(player.vel.length() - (Vector3.UP * player.GRAVITY * 0.1).length()).is_greater(
		player.AIR_TARGET_SPEED / 2.0
	)
	# test moving forward, not accelerating (NOTE : not testing speed conservation because move_towards makes the player loose a bit of speed)
	player.dir = Vector3.FORWARD.rotated(Vector3.UP, PI / 6.0)
	player.input_movement_vector = Vector2(0, 1)
	player.current_speed = player.AIR_TARGET_SPEED * 2.0
	player.vel = Vector3.FORWARD * player.current_speed
	player._air_movement(0.1)
	assert_float(player.vel.x).is_negative()  # checks if the velocity angle actually moved to the desired direction (RIGHT < 0)


func test_add_movement_queue_to_vel() -> void:
	player.vel = Vector3.RIGHT
	player.add_velocity_vector(Vector3.FORWARD)
	player._add_movement_queue_to_vel()
	assert_vector3(player.vel).is_equal(Vector3.FORWARD + Vector3.RIGHT)

#==== UTILITIES =====
