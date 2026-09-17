extends RigidBody3D

@onready var label = %Label
@onready var pointer = %pointer

@onready var air_viscosity = 0.1

@export var float_force := 0.8
var water_drag := 0.001
var water_ang_drag := 0.005
@onready var water_viscosity = 0.7

@export var parachute_coefficient: float = 1.0

@export var swing_speed = 1.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var floaters = %FloaterContainer.get_children()

@onready var mast = %mast

@onready var keel_center = %keel_center
#@export_range(0.0, 1.0) var keel_efficiency:float = 0.9

@onready var sail_center = %sail_center
@export var wind_direction_vector = Vector3.ZERO
#@export_range(0.0, 1.0) var sail_efficiency:float = 0.9

@onready var rudder = %rudder
@onready var rudder_center = %rudder_center
#@export_range(0.0, 1.0) var rudder_efficiency:float = 0.9

@onready var start_basis := basis
@onready var start_pos := global_position

const water_height = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(_delta): 

	#For interaction with vertex waves, modify the following so each floater pulls water height from the same sampler2D as the shader 
	var wind_direction = wind_direction_vector.normalized()
	#print(wind_direction)
	for f in floaters:
		var depth = water_height - f.global_position.y
		if depth > 0: 
			apply_force(Vector3.UP * float_force * gravity * depth, f.global_position - global_position)

	var mast_swing_axis = -Input.get_axis("swing left", "swing right")
	mast.rotation.y += mast_swing_axis * swing_speed * 0.01
	mast.rotation.y = clamp(mast.rotation.y, -(PI/2), (PI/2))
	
	var rudder_turn_axis = Input.get_axis("turn left", "turn right")
	rudder.rotation.y = rudder_turn_axis * deg_to_rad(45)

	if Input.is_action_just_pressed("ui_select"):
		position = start_pos + Vector3(0.0, 0.0, -30)
		basis = start_basis
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		mast.rotation.y = 0
	use_sail0()
	use_rudder()
	use_keel()
	#DebugDraw3D.draw_line(pointer.global_position, pointer.global_position + wind_direction + global_position, Color(1.0, 0.5, 0.0, 1.0))

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

func use_sail0():
	var wind_speed = 30.0
	var sail_efficiency = 0.8
	var wind_direction = wind_direction_vector.normalized()
	var wind_vector = wind_direction * wind_speed
	var lifter_position = sail_center.global_position
	var lifter_vel = get_point_velocity(lifter_position)
	var apparent_wind = wind_vector - lifter_vel
	var v = apparent_wind
	var lifter_normal = sail_center.global_transform.basis.x
	var z = lifter_normal
	
	var y = v.cross(z).normalized()
	var x = (y.cross(z)).normalized()
	
	var theta_z = v.angle_to(z)
	var theta_x = v.angle_to(x)
	
	var deflect_force_vector = v.length() * air_viscosity * sail_efficiency * cos(theta_z) * z

	var bernoulli_force_vector = v.length() * air_viscosity * sail_efficiency * z * ((cos(2 * theta_x) + 1) * 0.5)
	if theta_z > PI/2:
		bernoulli_force_vector *= -1
	if theta_z >= deg_to_rad(85) and theta_z <= deg_to_rad(95):
		bernoulli_force_vector *= 0
	
	var force_vector = (deflect_force_vector + bernoulli_force_vector)/2
	
	if force_vector.length() <= 0.1:
		force_vector = Vector3.ZERO
	
	apply_force(force_vector, lifter_position - global_position)
	#DebugDraw3D.draw_line(lifter_position, lifter_position + force_vector, Color(0.0, 1.0, 0.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + z, Color(0.0, 0.0, 1.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + x, Color())
	#DebugDraw3D.draw_line(lifter_position, lifter_position + y, Color(1.0, 1.0, 0.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position - v, Color(1,0,0))
	
	
	
func use_keel():
	var keel_efficiency = 7.5
	var lifter_position = keel_center.global_position
	var lifter_vel = get_point_velocity(lifter_position)
	var v = -lifter_vel
	var lifter_normal = keel_center.global_transform.basis.x
	var z = lifter_normal
	
	var y = v.cross(z).normalized()
	var x = (y.cross(z)).normalized()
	
	var theta_z = v.angle_to(z)
	var theta_x = v.angle_to(x)
	
	var normal_force = z * (cos(theta_z)) * keel_efficiency
	
	var force_vector = v.length() * water_viscosity * (normal_force)
	
	if force_vector.length() <= 0.1:
		force_vector = Vector3.ZERO
	
	apply_force(force_vector, lifter_position - global_position)
	#DebugDraw3D.draw_line(lifter_position, lifter_position + force_vector, Color(0.0, 1.0, 0.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + lifter_normal, Color(0.0, 0.0, 1.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + x, Color())
	#DebugDraw3D.draw_line(lifter_position, lifter_position + y, Color(1.0, 1.0, 0.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + v, Color(1,0,0))

	#var z = force_vector.x
	#label.text += "\n" + str(z)

func use_rudder():
	var rudder_efficiency = 0.8
	var lifter_position = rudder_center.global_position
	var lifter_vel = get_point_velocity(lifter_position)
	var v = -lifter_vel
	var lifter_normal = rudder_center.global_transform.basis.x
	var z = lifter_normal
	var y = v.cross(z).normalized()
	var x = (y.cross(z)).normalized()
	
	var theta_z = v.angle_to(z)
	var theta_x = v.angle_to(x)
	
	var normal_force = z * (cos(theta_z)) 
	var force_vector = v.length() * water_viscosity * rudder_efficiency * normal_force
	
	if force_vector.length() <= 0.1:
		force_vector = Vector3.ZERO
	apply_force(force_vector, lifter_position - global_position)
	#DebugDraw3D.draw_line(lifter_position, lifter_position + force_vector, Color(0.0, 1.0, 0.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + lifter_normal, Color(0.0, 0.0, 1.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position + x, Color())
	#DebugDraw3D.draw_line(lifter_position, lifter_position + y, Color(1.0, 1.0, 0.0))
	#DebugDraw3D.draw_line(lifter_position, lifter_position - v, Color(1,0,0))

func get_point_velocity(point: Vector3)-> Vector3:
	return linear_velocity + angular_velocity.cross(point - global_transform.origin)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	#if submerged:
	state.linear_velocity *= 1 - water_drag
	state.angular_velocity *= 1 - water_ang_drag
