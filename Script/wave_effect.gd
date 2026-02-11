extends MeshInstance3D

## Temps total avant disparition
@export var duration: float = 0.55
## Durée des effets d'intro (fade in / scale in)
@export var spawn_effect_duration: float = 0.4
## Durée des effets d'outro (fade in / scale in)
@export var despawn_effect_duration: float = 0.1
## Taille maximale atteinte
@export var max_size: float = 0.15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector3.ZERO
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(self, "scale", Vector3.ONE, spawn_effect_duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "mesh:material:albedo_color:a", 0, despawn_effect_duration)\
		.set_delay(duration - despawn_effect_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	tween.chain().tween_callback(queue_free)
