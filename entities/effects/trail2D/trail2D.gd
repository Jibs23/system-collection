@icon("res://entities/effects/trail2D/icon_trail2D.png")
extends Line2D

@onready var trailed_object:Node2D = get_parent()

@export var MAX_LENGTH:int = 10
var trail_points:Array

func _process(_delta: float) -> void:
	if !trailed_object:
		push_warning(self," missing parrent.")
		queue_free()
	var pos = trailed_object.global_position
	
	trail_points.push_front(pos)
	if trail_points.size() >= MAX_LENGTH: 
		trail_points.pop_back()
	clear_points()
	
	for point in trail_points:
		add_point(point)
