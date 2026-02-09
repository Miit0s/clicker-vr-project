extends XROrigin3D

@onready var left_rigidbody_hand: RigidBody3D = $LeftRigidbodyHand
@onready var right_rigidbody_hand: RigidBody3D = $RightRigidbodyHand

@onready var left_hand: XRController3D = $LeftHand
@onready var right_hand: XRController3D = $RightHand

@export var coef_force: float = 300
@export var coef_torque: float = 6.0

func _physics_process(_delta: float) -> void:
	_move_rigidbody_hand_to_contrainst(left_rigidbody_hand, left_hand)
	_move_rigidbody_hand_to_contrainst(right_rigidbody_hand, right_hand)

func _move_rigidbody_hand_to_contrainst(rigidbody_hand: RigidBody3D , contrainst: Node3D):
	var move_delta: Vector3 = contrainst.global_position - rigidbody_hand.global_position
	rigidbody_hand.apply_central_force(move_delta * coef_force)
	
	var quat_rigidbody_hand: Quaternion = rigidbody_hand.quaternion
	var quat_constraint: Quaternion = contrainst.quaternion
	
	var quat_delta: Quaternion = quat_constraint * (quat_rigidbody_hand.inverse())
	var rotation_delta: Vector3 = Vector3(quat_delta.x, quat_delta.y, quat_delta.z) * quat_delta.w
	rigidbody_hand.apply_torque(rotation_delta * coef_torque)
