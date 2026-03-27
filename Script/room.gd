extends Node3D
class_name Room

signal button_pressed
signal collider_tricker

@export var button: BasicButton

func _on_basic_button_button_pressed() -> void:
	button_pressed.emit()

func validate_button():
	button.validate_button()
