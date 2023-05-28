extends Sprite3D
# pretty much the same of the rocket target
# Refactor : self explanatory, just need to find the correct folder and name and we're good


##### PUBLIC METHODS #####
func set_pos(hit_pos: Vector3, normal: Vector3) -> void:
	global_transform.origin = hit_pos
	if (
		normal == Vector3.ZERO
		or normal.normalized() == Vector3.UP
		or normal.normalized() == Vector3.DOWN
	):
		rotation.x = PI / 2.0
	else:
		look_at(hit_pos + normal.normalized(), Vector3.UP)
