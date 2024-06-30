extends Node3D

# Чувствительность мыши
@export var mouse_sensitivity: float = 0.1
# Максимальный вертикальный угол (в градусах)
@export var max_vertical_angle: float = 90.0

var rotation_x: float = 0.0  # Вращение по оси X (вертикальное)
var rotation_y: float = 0.0  # Вращение по оси Y (горизонтальное)

@onready var camera: Camera3D = $Camera3D

func _ready():
	# Захват курсора мыши
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		# Обновление вращения на основе движения мыши и чувствительности
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity

		# Ограничение вертикального вращения, чтобы предотвратить переворот
		rotation_x = clamp(rotation_x, -max_vertical_angle, max_vertical_angle)
		
		# Применение вращений к камере и игроку
		camera.rotation_degrees = Vector3(rotation_x, 0, 0)
		rotation_degrees.y = rotation_y

		# Alternatively, using radians for rotation (if preferred):
		# camera.rotation.x = deg_to_rad(rotation_x)
		# rotation.y = deg_to_rad(rotation_y)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		# Переключение режима захвата мыши при нажатии клавиши Escape
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	# Update the rotations
	camera.rotation = Vector3(deg_to_rad(rotation_x), 0, 0)
	rotation.y = deg_to_rad(rotation_y)
