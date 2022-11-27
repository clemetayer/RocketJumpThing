extends CenterContainer
# Mouse icons for the tutorial UI

##### VARIABLES #####
#==== ONREADY ====
onready var onready_paths := {
	"up_arrow": $"VBoxContainer/UpArrowContainer",
	"down_arrow": $"VBoxContainer/DownArrowContainer",
	"left_arrow": $"VBoxContainer/HBoxContainer/LeftArrowContainer",
	"right_arrow": $"VBoxContainer/HBoxContainer/RightArrowContainer",
	"mouse":
	{
		"neutral": $"VBoxContainer/HBoxContainer/MouseContainer/MouseNeutral",
		"lclick": $"VBoxContainer/HBoxContainer/MouseContainer/MouseLClick",
		"rclick": $"VBoxContainer/HBoxContainer/MouseContainer/MouseRClick"
	}
}


##### PUBLIC METHODS ######
func set_elements(
	up: bool, down: bool, left: bool, right: bool, lclick: bool, rclick: bool
) -> void:
	yield(self, "ready")
	if onready_paths != null:
		if onready_paths.up_arrow != null:
			onready_paths.up_arrow.visible = up
		if onready_paths.down_arrow != null:
			onready_paths.down_arrow.visible = down
		if onready_paths.left_arrow != null:
			onready_paths.left_arrow.visible = left
		if onready_paths.right_arrow != null:
			onready_paths.right_arrow.visible = right
		if onready_paths.mouse.lclick != null:
			onready_paths.mouse.lclick.visible = lclick
		if onready_paths.mouse.rclick != null:
			onready_paths.mouse.rclick.visible = rclick
