extends RigidBody3D

@export var wind_force := 0.8

@export var float_force := 0.8
@export var water_drag := 0.01
@export var water_ang_drag := 0.03

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var floaters = %FloaterContainer.get_children()

@onready var sail = %sail

@onready var start_basis := basis
@onready var start_pos := global_position

const water_height = 0.0

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta): 
	submerged = false
	for f in floaters:
		var depth = water_height - f.global_position.y
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, f.global_position - global_position)

	var wind_vector: Vector3
	wind_vector.x = Input.get_axis("ui_left", "ui_right")
	wind_vector.z = Input.get_axis("ui_up", "ui_down")
	wind_vector.y = 0.0

	apply_force(wind_vector * wind_force, sail.global_position - global_position)

	if Input.is_action_just_pressed("ui_select"):
		position = (start_pos)
		basis = (start_basis)
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_ang_drag
