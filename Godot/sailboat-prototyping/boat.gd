extends RigidBody3D

@onready var floaters: Array[RayCast3D] = [%floater0, %floater1]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	for floater in floaters:
		floater.global_rotation = Vector3.ZERO
		do_buoyancy(floater)
		#print(floater.global_rotation)

func do_buoyancy(floater: RayCast3D) -> void:
	if floater.is_colliding():
		var collision_point = floater.get_collision_point()
		var floater_length = - floater.target_position.length()
		var floater_depth = floater.global_position.y - collision_point.y
		#print(floater_depth)
		var buoyancy = Vector3.UP * (floater_depth - floater_length)
		apply_force(buoyancy * 1, floater.position)
		print(buoyancy)
