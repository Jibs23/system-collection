extends Node

@onready var player:Node2D = get_parent()

func _process(_delta: float) -> void:
	if !player: return
	var dir :Vector2= Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	print("dir",dir)
	player.input_dir = dir
