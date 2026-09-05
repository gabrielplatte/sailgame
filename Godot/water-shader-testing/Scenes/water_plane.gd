extends MeshInstance3D


@onready var height_scalar: float


func _ready() -> void:
	height_scalar = 0
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
		
		height_scalar -= Input.get_axis("ui_up", "ui_down") 
		height_scalar = clamp(height_scalar, 0, 10)
		
		get_active_material(0).set_shader_parameter("height_scale", 10000)
		print("AAFdddfuuugh")
