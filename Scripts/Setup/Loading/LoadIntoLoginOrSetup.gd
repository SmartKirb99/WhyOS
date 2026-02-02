extends Node3D
##Handles "loading" into the account creation script

##Waits 10 Seconds, then goes to account creations
func _ready() -> void:
	await get_tree().create_timer(10).timeout
	get_tree().change_scene_to_file("res://Scenes/Setup/AccountCreation/AccountCreation.tscn")
