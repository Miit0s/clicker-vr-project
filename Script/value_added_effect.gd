extends Label3D

## Temps total avant disparition
@export var duration: float = 1.5
## Durée des effets d'intro (fade in / scale in)
@export var spawn_effect_duration: float = 0.3
## Durée des effets d'outro (fade in / scale in)
@export var despawn_effect_duration: float = 0.3
## Hauteur maximale atteinte
@export var height: float = 0.1
## Largeur du zigzag
@export var zigzag_amplitude: float = 0.1
## Nombre d'allers-retours
@export var zigzag_frequency: float = 3.0
@export var zigzag_max_amplitude_randomness: float = 0.2

var _start_pos: Vector3
var _random_amplitude: float = 0

func _ready() -> void:
	_random_amplitude = randf_range(0, zigzag_max_amplitude_randomness)
	
	#If opti needed, make a pull
	_start_pos = position
	scale = Vector3.ZERO
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_method(_update_trajectory, 0.0, 1.0, duration)
	tween.tween_property(self, "scale", Vector3.ONE, spawn_effect_duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, despawn_effect_duration)\
		.set_delay(duration - despawn_effect_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	tween.chain().tween_callback(queue_free)

func _update_trajectory(t: float) -> void:
	var current_y = _start_pos.y + (t * height)
	var current_x = _start_pos.x + sin(t * TAU * zigzag_frequency) * (zigzag_amplitude * _random_amplitude)
	
	position = Vector3(current_x, current_y, _start_pos.z)
