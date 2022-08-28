extends Node
class_name VariableManagerMock
# copy of the autoload script to store useful variables at runtime
# mocked for test purposes

##### VARIABLES #####
#---- SCENE UTILS -----
var chronometer := {"level": 0}  # chronometer values in milliseconds
var scene_unloading := false  # usefull to avoid making the game crash in some cases where the game is running and unloading at the same time

#---- MENUS -----
var pause_enabled := false
var end_level_enabled := false
