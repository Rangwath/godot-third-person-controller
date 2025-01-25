class_name Player extends CharacterBody3D

@export var movement_speed: float = 250
@export var jump_strength: float = 7
@export var gravity_multiplier: float = 2
@export var falling_threshold: float = -7

@onready var camera: Camera3D = $CameraRoot/CameraYaw/CameraPitch/SpringArm3D/Camera
@onready var animation_player: AnimationPlayer = $PlayerModel/AnimationPlayer

var rotation_direction: float


func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("ui_cancel"):
			get_tree().quit()


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	
	handle_jumping()
	
	var input_direction: Vector2 = handle_horizontal_input(delta)
	
	move_and_slide()
	
	handle_rotation(delta)
	
	handle_animations(input_direction)


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * delta


func handle_jumping() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strength


func handle_horizontal_input(delta: float) -> Vector2:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input:= Vector3.ZERO

	input.x = input_direction.x
	input.z = input_direction.y
	
	# Rotate input according to camera rotation
	input = input.rotated(Vector3.UP, camera.global_rotation.y).normalized()
	
	velocity.x = input.x * movement_speed * delta
	velocity.z = input.z * movement_speed * delta
	
	return input_direction


func handle_rotation(delta: float) -> void:
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(-velocity.z, -velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)


func handle_animations(input_direction: Vector2) -> void:
	if is_on_floor():
		if input_direction != Vector2.ZERO:
			if animation_player.current_animation != "walk":
				animation_player.play("walk", 0.1)
		else:
			if animation_player.current_animation != "idle":
				animation_player.play("idle", 0.1)
	else:
		if velocity.y < falling_threshold:
			if animation_player.current_animation != "fall":
				animation_player.play("fall", 0.1)
		elif animation_player.current_animation != "jump":
			animation_player.play("jump", 0.1)
