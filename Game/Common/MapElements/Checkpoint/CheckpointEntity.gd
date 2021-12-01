tool
extends QodotEntity
class_name CheckpointEntity
# Checkpoint entity declaration


func update_properties():
	# Separate executions for editor and true execution because qodot is a bit weird (or i did not understood it well)
	if Engine.editor_hint:
		if 'angles' in properties and is_inside_tree():
			var checkpoint := $Checkpoint
			checkpoint.rotate(checkpoint.global_transform.basis.x, deg2rad(180 + properties['angles'].x))
			checkpoint.rotate(checkpoint.global_transform.basis.y, deg2rad(180 + properties['angles'].y))
			checkpoint.rotate(checkpoint.global_transform.basis.z, deg2rad(180 + properties['angles'].z))
	else:
		if 'angles' in properties:
			yield(self, "tree_entered")
			var checkpoint := $Checkpoint
			yield(checkpoint, "tree_entered")
			checkpoint.rotate(checkpoint.global_transform.basis.x, deg2rad(180 + properties['angles'].x))
			checkpoint.rotate(checkpoint.global_transform.basis.y, deg2rad(180 + properties['angles'].y))
			checkpoint.rotate(checkpoint.global_transform.basis.z, deg2rad(180 + properties['angles'].z))
