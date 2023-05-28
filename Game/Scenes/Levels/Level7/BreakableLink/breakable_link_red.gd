extends BreakableLink
# Red breakable link that destroys the entity


##### PROTECTED METHODS #####
func _explode() -> void:
	._explode()
	var entity = get_tree().get_nodes_in_group(GlobalConstants.THE_ENTITY_GROUP)[0]
	if entity != null and is_instance_valid(entity):
		entity.hurt()
