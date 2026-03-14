extends Area2D
class_name Bullet

@export var speed: float = 3000.0
@export var max_distance: float = 120000.0

var direction: Vector2 = Vector2.RIGHT
var start_position: Vector2

func setup(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _ready() -> void:
	start_position = global_position
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	rotation = direction.angle()

	if global_position.distance_to(start_position) >= max_distance:
		queue_free()

func _on_body_entered(_body: Node) -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
