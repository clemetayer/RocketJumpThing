extends Area
# Handles the rocket explosion

##### VARIABLES #####
#---- CONSTANTS -----
const NODE_PATHS = {
	"collision": @"CollisionShape",
	"timer": @"ExplosionDecay",
	"animation": @"ExplosionAnimation",
	"explosion_audio": @"ExplosionAudio"
}
const ANIMATIONS = {"explode": "explode"}
const EXPLOSION_POWER := 15  # power of the explosion

#---- EXPORTS -----
export(Vector3) var EXPLOSION_POSITION


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	FunctionUtils.log_connect(get_node(NODE_PATHS.timer), self, "timeout", "_on_Timer_timeout")
	FunctionUtils.log_connect(
		get_node(NODE_PATHS.animation),
		self,
		"animation_finished",
		"_on_AnimationPlayer_animation_finished"
	)
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")
	_explode()


##### PROTECTED METHODS #####
# triggers the explosion method
func _explode() -> void:
	get_node(NODE_PATHS.explosion_audio).play()
	global_transform.origin = EXPLOSION_POSITION
	get_node(NODE_PATHS.animation).play(ANIMATIONS.explode)
	get_node(NODE_PATHS.timer).start()


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var vector = (body.global_transform.origin - global_transform.origin) * EXPLOSION_POWER
		body.add_velocity_vector(vector)


# animation ended, remove the scene
func _on_AnimationPlayer_animation_finished(_name: String) -> void:
	queue_free()


# disables the explosion hitbox
func _on_Timer_timeout() -> void:
	get_node(NODE_PATHS.collision).disabled = true
