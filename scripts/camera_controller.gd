extends Node3D

@export var target: Node3D
@export var joypad_deadzone: float = 0.1

@onready var camera_yaw: Node3D = $CameraYaw
@onready var camera_pitch: Node3D = $CameraYaw/CameraPitch
@onready var camera: Camera3D = $CameraYaw/CameraPitch/SpringArm3D/Camera

var yaw: float = 0
var pitch: float = 0

var pitch_max: float = 75
var pitch_min: float = -55

var yaw_sensitivity_mouse: float = 0.07
var pitch_sensititivy_mouse: float = 0.07

var yaw_sensitivity_joypad: float = 2
var pitch_sensititivy_joypad: float = 2

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var is_joypad_connected = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.get_connected_joypads().size() > 0:
		is_joypad_connected = true


func _input(event: InputEvent) -> void:
	# Get camera yaw and pitch from mouse motion
	if event is InputEventMouseMotion:
		var mouse_event:= event as InputEventMouseMotion
		yaw += -mouse_event.relative.x * yaw_sensitivity_mouse
		pitch += -mouse_event.relative.y * pitch_sensititivy_mouse


func _physics_process(delta: float) -> void:
	# Get camera yaw and pitch from joypad/gamepad if connected
	if is_joypad_connected:
		var joy_axis_right_x = apply_deadzone(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
		var joy_axis_right_y = apply_deadzone(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		
		yaw += -joy_axis_right_x * yaw_sensitivity_joypad
		pitch += joy_axis_right_y * pitch_sensititivy_joypad
	
	self.position = self.position.lerp(target.global_position, delta * 15)
	
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	camera_yaw.rotation_degrees.y = lerp(camera_yaw.rotation_degrees.y, yaw, yaw_acceleration * delta)
	camera_pitch.rotation_degrees.x = lerp(camera_pitch.rotation_degrees.x, pitch, pitch_acceleration * delta)


func apply_deadzone(axis_value: float) -> float:
	if abs(axis_value) < joypad_deadzone:
		return 0
	return axis_value
