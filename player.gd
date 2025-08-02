extends RigidBody3D

# Constants - nilai seimbang untuk kontrol yang smooth
const THRUST_FORCE: float = 15.0       # Thrust power (lebih halus)
const ROTATION_TORQUE: float = 4.0     # Rotation speed (rasio 1:3.75)
const MAX_SPEED: float = 6.0          # Speed limiter (tidak terlalu cepat)

# Untuk kontrol yang lebih smooth
const ACCELERATION_SMOOTHING: float = 0.1

# Input actions - bisa di-customize di Input Map
const INPUT_THRUST: String = "ui_accept"
const INPUT_ROTATE_LEFT: String = "ui_left" 
const INPUT_ROTATE_RIGHT: String = "ui_right"

func _ready() -> void:
	# Set physics process untuk operasi fisika
	# _process() tidak diperlukan jika hanya handle physics
	pass

# Gunakan _physics_process untuk semua operasi physics
func _physics_process(delta: float) -> void:
	handle_thrust_input(delta)
	handle_rotation_input(delta)

func handle_thrust_input(delta: float) -> void:
	if Input.is_action_pressed(INPUT_THRUST):
		# Optional: Speed limiter untuk mencegah terlalu cepat
		if linear_velocity.length() < MAX_SPEED:
			var thrust_vector: Vector3 = basis.y * THRUST_FORCE
			apply_central_force(thrust_vector)

func handle_rotation_input(delta: float) -> void:
	var torque_z: float = 0.0
	
	if Input.is_action_pressed(INPUT_ROTATE_LEFT):
		torque_z += ROTATION_TORQUE
	
	if Input.is_action_pressed(INPUT_ROTATE_RIGHT):
		torque_z -= ROTATION_TORQUE
	
	# Optional: Smooth rotation dengan lerp
	if torque_z != 0.0:
		apply_torque(Vector3(0.0, 0.0, torque_z))
	else:
		# Perlambat rotasi ketika tidak ada input
		angular_velocity *= 0.95

# Alternative: Jika ingin lebih advanced dengan impulse
func handle_thrust_impulse() -> void:
	if Input.is_action_just_pressed(INPUT_THRUST):
		var impulse_vector: Vector3 = basis.y * THRUST_FORCE * 0.1
		apply_central_impulse(impulse_vector)


func _on_body_entered(body: Node) -> void:
	print(body.name) # Replace with function body.
