extends StaticBody3D

@onready var viewport = $SubViewport
@onready var mesh = $Quad

func _ready() -> void:
	viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)

##Handles interaction with the mouse, and maybe the raycast within the User scene
func handle_interaction(event: InputEvent, collision_point: Vector3):
	var local_point = mesh.to_local(collision_point)
	
	# I think this is for mapping to a 1.92x1.08 mesh for the viewport
	var uv = Vector2((local_point.x / 1.92) + 0.5, (local_point.z / 1.08) + 0.5)
	var pixel_pos = uv * Vector2(viewport.size)
	var duplicated_event = event.duplicate()
	
	if duplicated_event is InputEventMouse:
		duplicated_event.position = pixel_pos
		if  duplicated_event is InputEventMouseMotion:
			duplicated_event.global_position = pixel_pos
	
	viewport.push_input(duplicated_event)
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_force_ui_focus(pixel_pos)
##Attempts to force UI focus
func _force_ui_focus(pos: Vector2):
	var gui_root = viewport.get_child(0)
	var target = _get_control_at_pos(gui_root, pos)
	if target:
		target.grab_focus()
	else:
		var owner = viewport.gui_get_focus_owner()
		if owner: owner.release_focus()
##Helper function to get what UI element at at a set of coordinates
func _get_control_at_pos(parent: Node, pos: Vector2) -> Control:
	if parent is Control and parent.visible:
		if parent.get_global_rect().has_point(pos):
			for i in range(parent.get_child_count()- 1, -1, -1):
				var child = parent.get_child(i)
				var result = _get_control_at_pos(child, pos)
				if result:
					return result
			if parent.mouse_filter != Control.MOUSE_FILTER_IGNORE:
				return parent
	return null
