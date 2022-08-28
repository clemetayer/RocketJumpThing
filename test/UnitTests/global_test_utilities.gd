extends Object
class_name GlobalTestUtilities

const mocked_signal_manager_path := "res://test/UnitTests/AutoLoadMocks/signal_manager_mock.tscn"
const mocked_song_manager_path := "res://test/UnitTests/AutoLoadMocks/standard_song_manager_mock.tscn"
const mocked_variable_manager_path := "res://test/UnitTests/AutoLoadMocks/variable_manager_mock.tscn"


func count_in_group_in_children(root: Node, group: String, recursive: bool) -> int:
	var cnt := 0
	if root.is_in_group(group):
		cnt += 1
	for child in root.get_children():
		if child.is_in_group(group):
			cnt += 1
		if recursive:
			cnt += _recur_count_group_in_children(child, group)
	return cnt


func _recur_count_group_in_children(node: Node, group: String) -> int:
	var cnt := 0
	for child in node.get_children():
		if child.is_in_group(group):
			cnt += 1
		cnt += _recur_count_group_in_children(child, group)
	return cnt
