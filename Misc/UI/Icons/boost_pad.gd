extends CenterContainer
# A boost pad icon for the tutorial UI

##### VARIABLES #####
#---- EXPORTS -----
export(bool) var enhanced

#---- STANDARD -----
#==== ONREADY ====
onready var onready_paths := {"enhanced_label": $"HBoxContainer/EnhancedContainer/Enhanced"}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.enhanced_label.visible = enhanced
