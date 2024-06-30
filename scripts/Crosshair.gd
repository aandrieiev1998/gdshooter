extends Node

var sprites = []

@export_range (0, 10) var minGap: float # Зазор между частями перекрестия
@export_range (0, 10) var maxGap: float
@export_range (0, 10) var length: float # Зазор между частями перекрестия
@export_range (0, 10) var width: float # Зазор между частями перекрестия

var gap
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gap = Vector2(minGap, maxGap)
	_initCrosshair()
	
	MouseHandler.main_action.connect(_handleMouseAction)
	
			
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_updateCrosshair(delta)
	pass
	
func _handleMouseAction():
	progress = 1
	pass
	
func _initCrosshair():
	sprites.resize(4)
	# Получение размеров вьюпорта
	var viewport_rect = get_viewport().get_visible_rect()
	var center = viewport_rect.size / 2
	
	var image = Image.create(1, 1, false, Image.FORMAT_RGB8)
	image.fill(Color.RED)  # Заполнение белым цветом
	var texture = ImageTexture.create_from_image(image) # Создание текстуры из изображения
	
	for i in 4:
		var sprite = Sprite2D.new() # Создание нового спрайта
		sprite.texture = texture # Назначение текстуры спрайту
		sprite.centered = true # Установка центра спрайта в центр изображения
		sprite.position = viewport_rect.size / 2 # Установка позиции спрайта в центр экрана
		
		if i % 2 == 0:
			sprite.scale = Vector2(width, length)
		else:
			sprite.scale = Vector2(length, width)
			
		match i:
			0:
				sprite.position = center + Vector2(0, -minGap - length)  # Верхняя линия
			1:
				sprite.position = center + Vector2(minGap + length, 0)   # Правая линия
			2:
				sprite.position = center + Vector2(0, minGap + length)   # Нижняя линия
			3:
				sprite.position = center + Vector2(-minGap - length, 0)  # Левая линия
		
		# Добавление спрайта как дочернего элемента к текущему узлу
		add_child(sprite)
		sprites[i] = sprite

func _updateCrosshair(delta):
	# Получение размеров вьюпорта
	var viewport_rect = get_viewport().get_visible_rect()
	var center = viewport_rect.size / 2
	
	minGap = lerp(gap.x, gap.y, progress)
	progress -= delta * 3
	progress = clamp(progress, 0, 1)
	
	for i in 4:
		var sprite = sprites[i]
		sprite.position = viewport_rect.size / 2 # Установка позиции спрайта в центр экрана
		
		if i % 2 == 0:
			sprite.scale = Vector2(width, length)
		else:
			sprite.scale = Vector2(length, width)
			
		match i:
			0:
				sprite.position = center + Vector2(0, -minGap - length)  # Верхняя линия
			1:
				sprite.position = center + Vector2(minGap + length, 0)   # Правая линия
			2:
				sprite.position = center + Vector2(0, minGap + length)   # Нижняя линия
			3:
				sprite.position = center + Vector2(-minGap - length, 0)  # Левая линия
