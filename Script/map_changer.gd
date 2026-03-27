extends Node3D

@export var maps: Array[PackedScene]

@export var min_click_before_change: int = 5
@export var max_click_before_change: int = 15
@export var value_to_reach: int = 20

@export var player: Player

var current_map: Room = null
var number_of_click: int = 0
var _number_of_click_needed: int = 0
var _room_need_to_be_reset: bool = false

func _ready() -> void:
	switch_map()

func switch_map():
	var map_instance: Room = maps.pop_front().instantiate()
	
	if current_map != null: remove_child(current_map)
	add_child(map_instance)
	current_map = map_instance
	
	_number_of_click_needed = randi_range(min_click_before_change, max_click_before_change)
	
	current_map.button_pressed.connect(_on_button_clicked)

func validate_room_button():
	current_map.validate_button()

func _on_button_clicked():
	number_of_click += 1
	player.update_click_count(str(number_of_click))
	
	if number_of_click == _number_of_click_needed and not _room_need_to_be_reset: 
		switch_map()
		_room_need_to_be_reset = true
	if number_of_click >= value_to_reach: validate_room_button()

func _on_collider_trigger():
	pass
