extends Node3D

@export var target: Node3D

@onready var camera_yaw: Node3D = $CameraYaw
@onready var camera_pitch: Node3D = $CameraYaw/CameraPitch
@onready var camera: Camera3D = $CameraYaw/CameraPitch/SpringArm3D/Camera

var yaw: float = 0
var pitch: float = 0

var pitch_max: float = 75
var pitch_min: float = -55

var yaw_sensitivity: float = 0.07
var pitch_sensititivy: float = 0.07

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event:= event as InputEventMouseMotion
		yaw += -mouse_event.relative.x * yaw_sensitivity
		pitch += -mouse_event.relative.y * pitch_sensititivy


func _physics_process(delta: float) -> void:
	self.position = self.position.lerp(target.global_position, delta * 15)
	
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	camera_yaw.rotation_degrees.y = lerp(camera_yaw.rotation_degrees.y, yaw, yaw_acceleration * delta)
	camera_pitch.rotation_degrees.x = lerp(camera_pitch.rotation_degrees.x, pitch, pitch_acceleration * delta)
