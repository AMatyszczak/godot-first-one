extends StaticBody3D

@onready var interactable: Area3D = $Interactable
@onready var sprite_2d: Sprite3D = $Sprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	interactable.interact = _on_interact

func _on_interact() -> void:
	print("LOL interact!")
