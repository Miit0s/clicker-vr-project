extends XROrigin3D

@onready var left_rigidbody_hand: RigidBody3D = $LeftRigidbodyHand
@onready var right_rigidbody_hand: RigidBody3D = $RightRigidbodyHand

@onready var left_hand: XRController3D = $LeftPreviewHand
@onready var right_hand: XRController3D = $RightPreviewHand

@onready var left_preview_tracking_hand: XRNode3D = $LeftPreviewTrackingHand
@onready var right_preview_tracking_hand: XRNode3D = $RightPreviewTrackingHand

@onready var left_tracked_rigidbody_hand: RigidBody3D = $LeftTrackedRigidbodyHand
@onready var right_tracked_rigidbody_hand: RigidBody3D = $RightTrackedRigidbodyHand

@export var coef_force: float = 300
@export var coef_torque: float = 6.0

@export var coef_force_hand_tracking: float = 500
@export var coef_torque_hand_tracking: float = 500

func _physics_process(_delta: float) -> void:
	_move_rigidbody_hand_to_contrainst(left_rigidbody_hand, left_hand, coef_force, coef_torque)
	_move_rigidbody_hand_to_contrainst(right_rigidbody_hand, right_hand, coef_force, coef_torque)
	
	_move_rigidbody_hand_to_contrainst(left_tracked_rigidbody_hand, left_preview_tracking_hand, coef_force_hand_tracking, coef_torque_hand_tracking)
	_move_rigidbody_hand_to_contrainst(right_tracked_rigidbody_hand, right_preview_tracking_hand, coef_force_hand_tracking, coef_torque_hand_tracking)

func _move_rigidbody_hand_to_contrainst(rigidbody_hand: RigidBody3D , contrainst: Node3D, force_multi: float, torque_multi: float):
	var move_delta: Vector3 = contrainst.global_position - rigidbody_hand.global_position
	rigidbody_hand.apply_central_force(move_delta * force_multi)
	
	var quat_rigidbody_hand: Quaternion = rigidbody_hand.quaternion
	var quat_constraint: Quaternion = contrainst.quaternion
	
	var quat_delta: Quaternion = quat_constraint * (quat_rigidbody_hand.inverse())
	var rotation_delta: Vector3 = Vector3(quat_delta.x, quat_delta.y, quat_delta.z) * quat_delta.w
	rigidbody_hand.apply_torque(rotation_delta * torque_multi)


func _on_left_preview_tracking_hand_tracking_changed(tracking: bool) -> void:
	left_hand.visible = !tracking
	left_rigidbody_hand.visible = !tracking
	
	left_tracked_rigidbody_hand.visible = tracking


func _on_right_preview_tracking_hand_tracking_changed(tracking: bool) -> void:
	right_hand.visible = !tracking
	right_rigidbody_hand.visible = !tracking
	
	right_tracked_rigidbody_hand.visible = tracking
