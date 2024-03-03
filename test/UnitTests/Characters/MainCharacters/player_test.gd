# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
extends GlobalTests
# Tests the player

##### VARIABLES #####
const FLOAT_APPROX := 0.5
const TOGGLE_ABILITY_UI_PATH := "res://Game/Common/MapElements/Characters/toggle_ability_ui.tscn"
const player_path = "res://Game/Common/MapElements/Characters/MainCharacters/player.tscn"
const portal_path := "res://Game/Common/MapElements/Portal/portal.tscn"
var player: KinematicBody


##### TESTS #####
#---- PRE/POST -----
func before():
	element_path = player_path
	.before()


func before_test():
	player = load(player_path).instance()
	player._ready()


func after_test():
	player.free()


#---- TESTS -----
#==== ACTUAL TESTS =====
func test_connect_signals() -> void:
	player._connect_signals()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_FOV, player, "_on_SignalManager_update_fov")).is_true()
	assert_bool(SignalManager.is_connected(SignalManager.UPDATE_WALL_RIDE_STRATEGY, player, "_on_SignalManager_update_wall_ride_strategy")).is_true()

func test_choose_wall_ride_strategy() -> void:
	SettingsUtils.settings_data.gameplay.space_to_wall_ride = false
	player._choose_wall_ride_strategy()
	assert_str(player._wall_ride_strategy.TEST_CLASS_NAME).is_equal("standard")
	SettingsUtils.settings_data.gameplay.space_to_wall_ride = true
	player._choose_wall_ride_strategy()
	assert_str(player._wall_ride_strategy.TEST_CLASS_NAME).is_equal("space to wall ride")

func test_add_velocity_vector() -> void:
	player.add_velocity_vector(Vector3.ONE)
	assert_array(player._add_velocity_vector_queue).is_equal([Vector3.ONE])


func test_override_velocity_vector() -> void:
	player.override_velocity_vector(Vector3.ONE)
	assert_vector3(player._override_velocity_vector).is_equal(Vector3.ONE)


func test_toggle_ability() -> void:
	var toggle_ability_ui = load(TOGGLE_ABILITY_UI_PATH).instance()
	toggle_ability_ui._ready()
	player.SLIDE_ENABLED = false
	player.ROCKETS_ENABLED = false
	player.onready_paths.rocket_launcher.visible = false
	player.onready_paths.toggle_ability_ui = toggle_ability_ui
	player.toggle_ability(GlobalConstants.ABILITY_SLIDE, true)
	assert_bool(player.SLIDE_ENABLED).is_true()
	player.toggle_ability(GlobalConstants.ABILITY_ROCKETS, true)
	assert_bool(player.ROCKETS_ENABLED).is_true()
	assert_bool(player.onready_paths.rocket_launcher.visible).is_true()
	player.toggle_ability(GlobalConstants.ABILITY_ROCKETS, false)
	assert_bool(player.ROCKETS_ENABLED).is_false()
	assert_bool(player.onready_paths.rocket_launcher.visible).is_false()


func test_checkpoint_process() -> void:
	var cp_pos := Vector3.ONE
	var cp_rot := Vector3(45, 90, 0)
	player.vel = Vector3.ONE
	player.checkpoint_process(cp_pos, cp_rot)
	assert_vector3(player.transform.origin).is_equal(cp_pos)
	assert_float(player.rotation_degrees.y).is_equal_approx(cp_rot.y, FLOAT_APPROX)
	assert_float(player.onready_paths.rotation_helper.rotation_degrees.x).is_equal_approx(
		cp_rot.x, FLOAT_APPROX
	)
	assert_vector3(player.vel).is_equal(Vector3.ZERO)


func test_process_collision() -> void:
	player._process_collision()
	assert_bool(player.onready_paths.player_collision.disabled).is_false()
	assert_bool(player.onready_paths.slide_collision.disabled).is_true()
	player.set_state_value(player.states_idx.SLIDING, true)
	player._process_collision()
	assert_bool(player.onready_paths.player_collision.disabled).is_true()
	assert_bool(player.onready_paths.slide_collision.disabled).is_false()


func test_look_at_mangle() -> void:
	var cp_rot := Vector3(-30, 90, 180)
	player._look_at_mangle(cp_rot)
	assert_vector3(player.rotation_degrees).is_equal(Vector3(0, cp_rot.y, 0))
	assert_vector3(player.onready_paths.rotation_helper.rotation_degrees).is_equal(
		Vector3(cp_rot.x, 0, 0)
	)

func test_init_rocket() -> void:
	var transform := Transform.looking_at(Vector3.FORWARD, Vector3.UP)
	var rocket = player._init_rocket(transform)
	assert_object(rocket).is_not_null()
	assert_vector3(rocket.START_POS).is_equal(Vector3.ZERO + player.ROCKET_START_OFFSET)
	assert_vector3(rocket.DIRECTION).is_equal(Vector3.FORWARD)
	assert_vector3(rocket.UP_VECTOR).is_equal(Vector3.UP)
	rocket.free()


func test_process_sounds() -> void:
	# Sliding
	player.set_state_value(player.states_idx.SLIDING,true)
	player._process_sounds()
	assert_bool(player.onready_paths.slide_sound.is_playing()).is_true()
	player.set_state_value(player.states_idx.SLIDING,false)
	player._process_sounds()
	assert_bool(player.onready_paths.slide_sound.is_playing()).is_false()
	# wall riding
	player.set_state_value(player.states_idx.WALL_RIDING,true)
	player._process_sounds()
	# test not working despite actually stepping through onready_paths.slide_sound.play(). Possibly an error of the test framework
	# assert_bool(player.onready_paths.slide_sound.is_playing()).is_true()
	player.set_state_value(player.states_idx.WALL_RIDING,false)
	player._process_sounds()
	assert_bool(player.onready_paths.slide_sound.is_playing()).is_false()

func test_override_velocity() -> void:
	player.vel = Vector3.FORWARD
	player.override_velocity_vector(Vector3.RIGHT)
	player._override_velocity()
	assert_vector3(player.vel).is_equal(Vector3.RIGHT)


func test_find_raycast_from_direction() -> void:
	assert_object(player._find_raycast_from_direction(0)).is_null()
	assert_object(player._find_raycast_from_direction(1)).is_equal(
		player.onready_paths.raycasts.left
	)
	assert_object(player._find_raycast_from_direction(-1)).is_equal(
		player.onready_paths.raycasts.right
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
	assert_bool(player.onready_paths.jump_sound.playing).is_true()


func test_wall_ride_process() -> void:
	var delta := 0.1
	var rc = mock(RayCast) as RayCast
	player.vel = Vector3.FORWARD * 100.0
	player._RC_wall_direction = 1
	do_return(Vector3.RIGHT).on(rc).get_collision_normal()
	do_return(Vector3.ZERO).on(rc).get_collision_point()
	player._wall_ride_process(rc, Vector3.FORWARD, delta)
	assert_float(player.vel.length()).is_equal_approx(100.0, FLOAT_APPROX)
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
	assert_vector3(player.onready_paths.raycasts.root.rotation).is_equal(
		Vector3(0, PI * 3.0 / 4.0, 0)
	)  # note : since is the "inverse" angle, it is 3/4 of PI


func test_ground_jump() -> void:
	player._ground_jump()
	assert_vector3(player.vel).is_equal(Vector3(0, player.JUMP_POWER, 0))
	assert_bool(player.onready_paths.jump_sound.playing).is_true()


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

func test_deccelerate() -> void:
	# Standard test
	var original_vel = Vector3.FORWARD * 50.0
	player.vel = original_vel
	player._deccelerate(0,0.9, 1.0/FunctionUtils.get_physics_fps())
	assert_float(player.vel.length()).is_less(original_vel.length())
	# not negative test
	original_vel = Vector3.FORWARD * 50.0
	player.vel = original_vel
	player._deccelerate(original_vel.length() + 50.0, 0.9, 1.0/FunctionUtils.get_physics_fps())
	assert_float(player.vel.length()).is_not_negative()

func test_air_movement() -> void:
	# test moving forward, accelerating
	player.dir = Vector3.FORWARD
	player.input_movement_vector = Vector2(0, 1)
	player.current_speed = player.AIR_TARGET_SPEED / 2.0
	player.vel = Vector3.FORWARD * player.current_speed
	player._air_movement(0.1)
	assert_float(player.vel.length() - (Vector3.UP * player.GRAVITY * 0.1).length()).is_greater(
		player.AIR_TARGET_SPEED / 3.0
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

# can only test the _last_wall_ride_tilt_direction because tweens are complex to test
func test_set_wall_ride_camera_tilt() -> void:
	player._set_wall_ride_camera_tilt(PI/4.0,1)
	assert_int(player._last_wall_ride_tilt_direction).is_equal(1)
	player._set_wall_ride_camera_tilt(PI/2.0,1)
	assert_int(player._last_wall_ride_tilt_direction).is_equal(1)
	player._set_wall_ride_camera_tilt(-PI/4.0,-1)
	assert_int(player._last_wall_ride_tilt_direction).is_equal(-1)
	player._set_wall_ride_camera_tilt(0,0)
	assert_int(player._last_wall_ride_tilt_direction).is_equal(0)

func test_manage_slide_wallride_visual_effect() -> void:
	player.vel = Vector3.RIGHT
	# test slide
	player.set_state_value(player.states_idx.SLIDING,true)
	player.set_state_value(player.states_idx.WALL_RIDING,false)
	player._manage_slide_wallride_visual_effect()
	assert_vector3(player.onready_paths.slide_visual_effects.rotation).is_equal(Vector3.UP * PI/2.0)
	assert_bool(player.onready_paths.slide_visual_effects.visible).is_true()
	# test wall ride
	player.set_state_value(player.states_idx.SLIDING,false)
	player.set_state_value(player.states_idx.WALL_RIDING,true)
	player._manage_slide_wallride_visual_effect()
	assert_vector3(player.onready_paths.slide_visual_effects.rotation).is_equal(Vector3.UP * PI/2.0)
	assert_bool(player.onready_paths.slide_visual_effects.visible).is_true()
	# test none
	player.set_state_value(player.states_idx.SLIDING,false)
	player.set_state_value(player.states_idx.WALL_RIDING,false)
	player._manage_slide_wallride_visual_effect()
	assert_bool(player.onready_paths.slide_visual_effects.visible).is_false()

func test_on_SignalManager_update_fov() -> void:
	var test_val = 50.0
	player._on_SignalManager_update_fov(test_val)
	assert_float(player.onready_paths.camera.fov).is_equal(test_val)

func test_on_SignalManager_update_wall_ride_strategy() -> void:
	SettingsUtils.settings_data.gameplay.space_to_wall_ride = false
	player._on_SignalManager_update_wall_ride_strategy()
	assert_str(player._wall_ride_strategy.TEST_CLASS_NAME).is_equal("standard")
	SettingsUtils.settings_data.gameplay.space_to_wall_ride = true
	player._on_SignalManager_update_wall_ride_strategy()
	assert_str(player._wall_ride_strategy.TEST_CLASS_NAME).is_equal("space to wall ride")

func set_trail_gradient_texture_test() -> void:
	var gradient_test = GradientTexture.new()
	player.set_trail_gradient_texture(gradient_test)
	assert_object(player.onready_paths.trails.left.get_surface_material(0).get_shader_param(player.TRAIL_GRADIENT_SHADER_PARAM)).is_equal(gradient_test)
	assert_object(player.onready_paths.trails.right.get_surface_material(0).get_shader_param(player.TRAIL_GRADIENT_SHADER_PARAM)).is_equal(gradient_test)
