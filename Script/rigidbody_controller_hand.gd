extends RigidBody3D

@export var collision_shapes_3d: Array[CollisionShape3D]

func _on_visibility_changed() -> void:
	for shape in collision_shapes_3d:
		shape.disabled = !self.visible
