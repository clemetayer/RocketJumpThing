extends Node
# An autoload script to store useful variables at runtime

##### VARIABLES #####
#---- SCENE UTILS -----
var chronometer := {"level": 0}  # chronometer values in milliseconds
var scene_unloading := false  # usefull to avoid making the game crash in some cases where the game is running and unloading at the same time

#---- MENUS -----
var pause_enabled := false
var end_level_enabled := false
