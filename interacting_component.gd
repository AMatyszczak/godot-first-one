extends Node3D

@onready var interact_label: Label3D = $InteractLabel
var current_interactions := []
var can_interact := true

func _on_interact_range_area_entered(area: Area3D) -> void:
	print("entered!")
	current_interactions.push_back(area);

func _on_interact_range_area_exited(area: Area3D) -> void:
	current_interactions.erase(area);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions:
			can_interact = false
			interact_label.hide()
			await current_interactions[0].interact.call()
			
			can_interact = true
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if can_interact and current_interactions:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name			
		
			interact_label.show()
	else:
		interact_label.hide()
		
		
func _sort_by_nearest(area1: Area3D, area2: Area3D):
	var area1_dist: float = global_position.distance_to(area1.global_position)
	var area2_dist: float = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist;
