extends RigidBody3D

@onready var floaters: Array[RayCast3D] = [%floater0, %floater1, %floater2]
@onready var input_vector: Vector2
@onready var input_vector_to_3d: Vector3
@onready var force_vector = to_local(Vector3())
@export var wind_scale: float
@export var wind_position = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	for floater in floaters:
		floater.global_rotation = Vector3.ZERO
		do_buoyancy(floater)
		print(floater.global_rotation)

	input_vector = Input.get_vector("left", "right", "forward", "back")
	input_vector_to_3d = Vector3(input_vector.x, 0, input_vector.y)
	force_vector = input_vector_to_3d * wind_scale

	apply_force(force_vector, wind_position)
	DebugDraw3D.draw_arrow_ray(wind_position, force_vector, force_vector.length())
	#print(force_vector)

	do_righting_forces()

func do_buoyancy(floater: RayCast3D) -> void:
	if floater.is_colliding():
		var collision_point = floater.get_collision_point()
		var floater_length = - floater.target_position.length()
		var floater_depth = collision_point.y - floater.global_position.y
		#print(floater_depth)
		var buoyancy = Vector3.UP * floater_depth
		apply_force(buoyancy, floater.position + to_local(Vector3(0, 0.6, 0)))
		print(buoyancy)
func do_righting_forces():
	print(global_transform.basis.x)
