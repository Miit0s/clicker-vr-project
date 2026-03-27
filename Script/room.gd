extends Node3D
class_name Room

signal button_pressed
signal collider_trigger

@export var button: BasicButton
@export var door: Node3D

func _on_basic_button_button_pressed() -> void:
	button_pressed.emit()

func validate_button():
	button.validate_button()


func _on_area_3d_body_entered(_body: Node3D) -> void:
	collider_trigger.emit()


func _on_open_door_area_body_entered(_body: Node3D) -> void:
	door.hide()
