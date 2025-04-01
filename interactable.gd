extends Area3D

@export var interact_name: String = ""
@export var is_interactable: bool = true
@onready var label: Label3D = $InteractLabel


func _ready() -> void:
	pass

var interact: Callable = func():
	pass

var hide_interact_label: Callable = func():
	label.hide()

var show_interact_label: Callable = func():
	label.show()