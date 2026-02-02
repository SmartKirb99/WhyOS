extends Camera3D

##The direction you're looking, or something
var look_dir: Vector2
##The camera, I copied this from a 1st person controller
@onready var camera = self
##The camera sensitivity
var camera_sens = 50
##If the mouse should be captured, AKA, cannot move from the center of the screen, it's this way for many First Person Games
var capMouse = true
##Raycast so the user can interact with GUIs
@onready var raycast = $RayCast3D

##If the user presses ESC, then the mouse becomes visible and you're technically no longer in first person
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		capMouse = !capMouse
	if capMouse:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_rotate_camera(delta)
##Handles mouse motion events, and also raycast stuff so clicking works
func _input(event: InputEvent):
	if event is InputEventMouseMotion: 
		look_dir = event.relative * 0.01
		_send_phys_event_to_gui(event)
	elif event.is_action_pressed("Click"):
		_send_phys_event_to_gui(event)

func _send_phys_event_to_gui(event):
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.has_method("handle_mouse_input"):
			collider.handle_mouse_input(event, raycast.get_collision_point())

##Handles camera rotation
func _rotate_camera(delta: float, sens_mod: float = 1.0):
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	look_dir += input
	rotation.y -= look_dir.x * camera_sens * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO
