extends CharacterBody3D
 
@export var hold_position: Node3D 
@onready var camera: Camera3D = $Camera_Controller/Camera_Target/Camera
@onready var camera_controller: Node3D = $Camera_Controller
@onready var cursor: Node3D = $Cursor


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var held_object: RigidBody3D = null

func _ready() -> void:
	camera_controller.set_as_top_level(true)
	cursor.set_as_top_level(true)

func _input(event):
	if event.is_action_pressed("interact"):
		if held_object == null:
			attempt_pickup()
		else:
			drop_item()

func attempt_pickup():
	var space_state = get_world_3d().direct_space_state
	var origin = global_transform.origin
	var end = origin + transform.basis.z * -3  # Forward direction check
#	var end = origin + global_transform.basis.z * -2  # Forward direction check
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	if result and result.collider is RigidBody3D:
		held_object = result.collider
		held_object.freeze = true  # Disable physics
		held_object.reparent(hold_position)
		held_object.transform = Transform3D(Basis(), Vector3(0, 0, 0))  # Center it

func drop_item():
	if held_object:
		held_object.reparent(get_tree().current_scene)  # Return to scene root
		held_object.global_transform.origin = hold_position.global_transform.origin
		held_object.freeze = false  # Re-enable physics
		held_object = null

func _physics_process(delta: float) -> void:
	
	look_at_cursor()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	
	move_and_slide()
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.15)
	
func look_at_cursor():
	var player_pos = global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = drop_plane.intersects_ray(from, to)

	if (cursor_pos != null):
		print("cursor_pos not null")
		cursor.global_transform.origin = cursor_pos + Vector3(0, 1, 0)
		look_at(cursor_pos, Vector3.UP)
	