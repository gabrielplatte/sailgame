extends MeshInstance3D

@onready var height_scalar: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	height_scalar = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
		
		height_scalar -= Input.get_axis("ui_up", "ui_down") / 500
		height_scalar = clamp(height_scalar, 0, 0.5)
		
		get_active_material(0).set_shader_parameter("height_scale", height_scalar)
