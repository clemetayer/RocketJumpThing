extends Node2D
# just a test camera

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var toggled := false


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("movement_forward"):
		direction.y += 1
	if Input.is_action_pressed("movement_backward"):
		direction.y -= 1
	if Input.is_action_pressed("movement_left"):
		direction.x -= 1
	if Input.is_action_pressed("movement_right"):
		direction.x += 1
	transform.origin += direction * delta * 100

	if Input.is_action_just_pressed("test"):
		toggled = not toggled
		GlobalScreenEffects.toggle_effect(GlobalScreenEffects.EFFECTS.glitch, toggled)
