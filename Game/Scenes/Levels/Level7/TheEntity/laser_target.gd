extends Sprite3D
# pretty much the same of the rocket target


##### PUBLIC METHODS #####
func set_pos(hit_pos: Vector3, normal: Vector3) -> void:
	global_transform.origin = hit_pos
	if (
		normal != Vector3.ZERO
		and normal.normalized() != Vector3.UP
		and normal.normalized() != Vector3.DOWN
	):
		look_at(hit_pos + normal, Vector3.UP)
