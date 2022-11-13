extends VBoxContainer
class_name CommonSettingsCategory
# A common class for a settings category
# Add the needed parameters as children

##### VARIABLES #####
#---- EXPORTS -----
export(String) var CATEGORY_NAME setget _set_category_name  # name of the settings category, can be a translation key

#==== ONREADY ====
onready var onready_paths := {"separator_label": $"Separator/SeparatorLabel"}


##### PROTECTED METHODS #####
func _set_category_name(category_name: String) -> void:
	if onready_paths != null:  # mostly to fix tests
		onready_paths.separator_label.text = tr(category_name)
