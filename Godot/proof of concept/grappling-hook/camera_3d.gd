extends Camera3D

const CAMERA_SPEED = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_delta = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	rotation.x -= camera_delta.y * delta * CAMERA_SPEED
	rotation.x = clamp(rotation.x, deg_to_rad(-70), deg_to_rad(70))
