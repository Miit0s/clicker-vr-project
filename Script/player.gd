extends CharacterBody3D
class_name  Player

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

@onready var left_hand: XRController3D = $XROrigin3D/LeftPreviewHand
@onready var xr_camera_3d: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var xr_origin_3d: XROrigin3D = $XROrigin3D

@onready var label_3d_on_controller: Label3D = $XROrigin3D/LeftRigidbodyHand/Label3D
@onready var label_3d_on_hand: Label3D = $XROrigin3D/LeftTrackedRigidbodyHand/Label3D

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
	
	update_position_based_to_camera_pos()

func update_click_count(new_value: String):
	label_3d_on_controller.text = new_value
	label_3d_on_hand.text = new_value

func update_position_based_to_camera_pos():
	var camera_transform: Transform3D = xr_origin_3d.transform * xr_camera_3d.transform
	var new_position: Vector3 = camera_transform.origin * Vector3(1, 0, 1)
	new_position = global_transform * new_position
	
	var original_position: Vector3 = global_position
	move_and_collide(new_position - original_position)
	
	var delta_movement = global_position - original_position
	delta_movement = basis.inverse() * delta_movement
	
	xr_origin_3d.position -= delta_movement
