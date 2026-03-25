extends CharacterBody3D

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

@onready var left_hand: XRController3D = $XROrigin3D/LeftHand
@onready var xr_camera_3d: XRCamera3D = $XROrigin3D/XRCamera3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = left_hand.get_vector2("primary")
	
	var direction: Vector3 = (xr_camera_3d.global_transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
