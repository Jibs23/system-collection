extends CharacterBody3D

## The speed character moves at.
@export var walk_speed:float = 5.0
## The height of the character jump.
@export var jump_strenght:float = 4.5

@export_range(0,90,1) var camera_look_lock: float = 90

@onready var head:Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D
@onready var hud: CanvasLayer = $HUD
@onready var crosshair_sprite: Sprite2D = $HUD/Container/Crosshair
## Mouse sensitivity. The value is devided by 1000.
@export_range(0.1,30,0.1) var look_sensitivity: float = 5:
	get:
		return look_sensitivity / 1000

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_strenght

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("fps_walk_left", "fps_walk_right", "fps_walk_forward", "fps_walk_backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

# Mouse look
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-camera_look_lock),deg_to_rad(camera_look_lock))
