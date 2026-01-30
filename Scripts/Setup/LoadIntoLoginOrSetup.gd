extends Node3D

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	print("Some test or something")
