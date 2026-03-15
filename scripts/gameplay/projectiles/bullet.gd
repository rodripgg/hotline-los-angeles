extends Area2D

@export var speed: float = 900.0
@export var max_distance: float = 1200.0

@export var shoot_particles_scene: PackedScene
@export var impact_particles_scene: PackedScene
@export var blood_particles_scene: PackedScene

var direction: Vector2 = Vector2.RIGHT
var start_position: Vector2
var has_collided: bool = false

func setup(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _ready() -> void:
	start_position = global_position

	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

	rotation = direction.angle()

	# Caso 1: salida de la bala desde la pistola
	_spawn_particles(shoot_particles_scene, global_position, direction.angle())

func _physics_process(delta: float) -> void:
	if has_collided:
		return

	global_position += direction * speed * delta
	rotation = direction.angle()

	if global_position.distance_to(start_position) >= max_distance:
		queue_free()

func _spawn_particles(
	scene: PackedScene,
	spawn_position: Vector2,
	spawn_rotation: float
) -> void:
	if scene == null:
		return

	var fx := scene.instantiate()

	if fx == null:
		return

	get_tree().current_scene.add_child(fx)

	if fx is Node2D:
		fx.global_position = spawn_position
		fx.rotation = spawn_rotation

	if fx is GPUParticles2D:
		fx.finished.connect(_on_fx_finished.bind(fx), CONNECT_ONE_SHOT)
		fx.restart()
		fx.emitting = true

func _on_fx_finished(fx: GPUParticles2D) -> void:
	if is_instance_valid(fx):
		fx.queue_free()

func _handle_hit(collider: Node) -> void:
	if has_collided:
		return

	has_collided = true
	var hit_pos := global_position - direction * 10.0
	# Caso 2: impacto con enemigo
	if collider.is_in_group("enemies"):
		_spawn_particles(blood_particles_scene, hit_pos, direction.angle())
	else:
		# Caso 3: impacto con objeto inanimado / mundo
		_spawn_particles(impact_particles_scene, hit_pos, direction.angle())

	queue_free()

func _on_body_entered(body: Node2D) -> void:
	_handle_hit(body)

func _on_area_entered(area: Area2D) -> void:
	_handle_hit(area)
