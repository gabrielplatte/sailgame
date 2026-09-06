extends RigidBody3D

@onready var label = %Label
@onready var pointer = %pointer

@export var wind_force := 1

@export var float_force := 0.8
@export var water_drag := 0.01
@export var water_ang_drag := 0.03

var incidence_angle: float
@export var parachute_coefficient: float = 1.0

@export var swing_speed = 1.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var floaters = %FloaterContainer.get_children()

@onready var mast = %mast

@onready var sail = %sail_center
@onready var wind_vector = Vector3(0.0, 0.0, 1.0)

@onready var start_basis := basis
@onready var start_pos := global_position

const water_height = 0.0

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta): 
	submerged = false
	
	#For interaction with vertex waves, modify the following so each floater pulls water height from the same sampler2D as the shader 
	for f in floaters:
		var depth = water_height - f.global_position.y
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, f.global_position - global_position)

	var swing_axis = Input.get_axis("swing left", "swing right")
	mast.rotation.y += swing_axis * swing_speed * 0.01
	mast.rotation.y = clamp(mast.rotation.y, -(PI/2), (PI/2))

	if Input.is_action_just_pressed("ui_select"):
		position = start_pos
		basis = start_basis
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		mast.rotation.y = 0

	var sail_normal = sail.global_transform.basis.x
	incidence_angle = sail_normal.angle_to(wind_vector)
	
	label.text = "Incidence angle: " + str(incidence_angle/PI)
	
	parachute()
	
	pointer.look_at(wind_vector)
	
# Temp code for testing, replace with sail function calls
	#var self_propel_vector: Vector3
	#self_propel_vector.x = Input.get_axis("ui_left", "ui_right")
	#self_propel_vector.z = Input.get_axis("ui_up", "ui_down")
	#self_propel_vector.y = 0.0
	#
	#var to_local = Vector3.FORWARD.angle_to(-global_transform.basis.z)
	#self_propel_vector = self_propel_vector.rotated(Vector3.UP, to_local)
#
	#var force = self_propel_vector.normalized() * wind_force
	#apply_force(force, sail.global_position - global_position)
# End temp code

func parachute():
	var scalar: float
	var i = incidence_angle/PI
	scalar = 4*i*i - 4*i +1

	var force_vector = scalar * parachute_coefficient * wind_force * wind_vector
	apply_force(force_vector, sail.global_position - global_position)
	label.text += "\n" + str(i)
	label.text += "\n" + str(scalar)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_ang_drag
