extends RigidBody3D 

@onready var interactable: Area3D = $Interactable
@onready var sprite_2d: Sprite3D = $Sprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	interactable.interact = _on_interact

func _on_interact() -> void:
	pass
#	var player = get_tree().get_first_node_in_group("player");
#	var player2 = get_tree().get_first_node_in_group("Player");
	
#	print("p, p2:", player, player2)
#	print_tree()
#	debug_print_tree(get_tree().current_scene)  # Start from the root scene

	
#	if held_by == null:
#		return player.attempt_pickup(self)
#	else:
#		return player.drop_item(self)
		
		
#func debug_print_tree(node: Node, indent: int = 0) -> void:
#	print("  ".repeat(indent) + node.name)  # Indent for hierarchy visualization
#	for child in node.get_children():
#		debug_print_tree(child, indent + 1)
