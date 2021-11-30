tool
extends QodotEntity
class_name CheckpointEntity
# Checkpoint entity declaration


func update_properties():
	var checkpoint := $Checkpoint
	if 'angles' in properties:
		var pitch = properties['angles'].x
		var yaw = properties['angles'].y
		var roll = properties['angles'].z
		checkpoint.rotate(checkpoint.global_transform.basis.y, deg2rad(180 + yaw))
		checkpoint.rotate(checkpoint.global_transform.basis.x, deg2rad(180 + pitch))
		checkpoint.rotate(checkpoint.global_transform.basis.z, deg2rad(180 + roll))
