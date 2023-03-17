tool
extends Resource
class_name MoverTravelDataArray
# Travel data for a mover (spatial that moves)
# Kind of a weird way to do this, but avoids the trenchbroom entity to get too complex

export(Array) var TRAVEL_DATA_ARRAY setget , get_travel_data


# To bypass godot's limitation for custom resources export hints
func get_travel_data() -> Array:
	if Engine.is_editor_hint():
		var travel_data = TRAVEL_DATA_ARRAY
		for travel_data_idx in range(travel_data.size()):
			if travel_data[travel_data_idx] == null:
				travel_data[travel_data_idx] = MoverTravelData.new()
		TRAVEL_DATA_ARRAY = travel_data
		return travel_data
	else:
		return TRAVEL_DATA_ARRAY
