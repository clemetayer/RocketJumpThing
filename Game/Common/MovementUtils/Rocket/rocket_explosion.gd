extends Area
# Handles the rocket explosion

##### VARIABLES #####
#---- CONSTANTS -----
const ANIMATIONS = {"explode": "explode"}
const EXPLOSION_POWER := 15  # power of the explosion

#---- EXPORTS -----
export(Vector3) var EXPLOSION_POSITION

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {
	"collision": $"CollisionShape",
	"timer": $"ExplosionDecay",
	"animation": $"ExplosionAnimation",
	"explosion_audio": $"ExplosionAudio"
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	_explode()


##### PROTECTED METHODS #####
func _connect_signals() -> void:
	FunctionUtils.log_connect(onready_paths.timer, self, "timeout", "_on_Timer_timeout")
	FunctionUtils.log_connect(
		onready_paths.animation,
		self,
		"animation_finished",
		"_on_AnimationPlayer_animation_finished"
	)
	FunctionUtils.log_connect(self, self, "body_entered", "_on_body_entered")


# triggers the explosion method
func _explode() -> void:
	onready_paths.explosion_audio.play()
	global_transform.origin = EXPLOSION_POSITION
	onready_paths.animation.play(ANIMATIONS.explode)
	onready_paths.timer.start()


##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node) -> void:
	if FunctionUtils.is_player(body):
		var vector = (body.global_transform.origin - global_transform.origin) * EXPLOSION_POWER
		body.add_velocity_vector(vector)


# animation ended, remove the scene
func _on_AnimationPlayer_animation_finished(_name: String) -> void:
	queue_free()


# disables the explosion hitbox
func _on_Timer_timeout() -> void:
	onready_paths.collision.disabled = true
