extends Node3D

signal button_pressed

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var button_effect_spawn_point: Marker3D = $RigidBody3D/ButtonEffectSpawnPoint

@export var down_size_for_reset: float = 0.010
@export var down_size_for_trigger: float = 0.018

@export var value_added_effect: PackedScene
@export var wave_effect: PackedScene

var _start_height: float
var _button_has_been_trigger: bool = false

func _ready() -> void:
	_start_height = rigid_body_3d.position.y

func _process(_delta: float) -> void:
	if (_start_height - down_size_for_trigger) >= rigid_body_3d.position.y:
		_button_pressed()
	elif rigid_body_3d.position.y >= (_start_height - down_size_for_reset):
		_button_has_been_trigger = false

func _button_pressed():
	if _button_has_been_trigger: return
	
	#Particle effet here
	_setup_button_effect(value_added_effect)
	_setup_button_effect(wave_effect)
	
	button_pressed.emit()
	
	_button_has_been_trigger = true

func _setup_button_effect(node_to_create: PackedScene):
	var new_node: Node3D = node_to_create.instantiate()
	new_node.position = self.to_local(button_effect_spawn_point.global_position)
	add_child(new_node)
