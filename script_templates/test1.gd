extends WAT.Test

# Doc : https://github.com/AlexDarigan/WAT

##### ENUMS #####
# enumerations

##### VARIABLES #####

##### PROCESSING #####
#func pre():
#    pass

#func post():
#    pass

#func start():
#    pass

#func end():
#    pass


func title() -> String:
	return "Test title"


##### UTILS #####
# Usefull general functions for the test


##### TEST FUNCTIONS #####
# Functions to be tested
func test_function() -> void:
	asserts.is_true(true, "True")
	asserts.is_false(false, "False")
	describe("Test description")
