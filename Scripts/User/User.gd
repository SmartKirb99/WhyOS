extends CharacterBody3D
##This script handles all code related to the user.

##Camera Sensitivity
@export var camera_sens = 0.5
##The direction that the user is looking
var look_dir: Vector2
##A boolean as to if the mouse should stay centered on the screen
var capMouse = true

##A Camera3D node
@onready var camera = $Camera3D
##A RayCast3D Node
@onready var raycast = $Camera3D/RayCast3D
##Puts the mouse into a captured mode (The mouse gets set to the middle and is invisible, pretty much all first person games use this, including Minecraft)
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
##Handles Camera Rotation, well, it calls _rotate_camera(delta), but checks if ESC is pressed, then if capMouse is true, then it calls that, elsewise, your mouse is visible
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		capMouse = !capMouse
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if capMouse else Input.MOUSE_MODE_VISIBLE #Oh, it's kinda like Jave with a one line if-else statement
	if capMouse:
		_rotate_camera(delta)
##Handles Raycast Input for a 3D GUI
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and capMouse:
		look_dir = event.relative
		_send_phys_event_to_gui(event)
	elif event.is_action_pressed("Click"):
		_send_phys_event_to_gui(event)
	elif event is InputEventKey:
		_send_phys_event_to_gui(event)
		
##Handles sending inputs to a GUI
func _send_phys_event_to_gui(event):
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.has_method("handle_interaction"):
			collider.handle_interaction(event, raycast.get_collision_point())
##Handles Camera Rotation
func _rotate_camera(delta: float):
	rotation.y -= look_dir.x * camera_sens * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO
