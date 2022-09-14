extends Particles
# Short script to make the particles """follow""" the player, to avoid drawing unnecessary particles##### SIGNALS ###### Node signals##### ENUMS ###### enumerations

##### VARIABLES #####
#---- EXPORTS -----
export(NodePath) var PLAYER

#---- STANDARD -----
#==== ONREADY ====
onready var onready_player = get_node_or_null(PLAYER)  # keeps an instance of the player to (probably ?) save some performances in _process


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if onready_player != null:
		global_transform.origin = onready_player.global_transform.origin
