extends CharacterBody2D

@export var move_speed: float = 1400.0
@export var fire_interval: float = 0.52
@export_enum("KeyboardMouse", "Gamepad") var control_scheme: int = 0
@export var joy_id: int = 0
@export var bullet_scene: PackedScene

@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var muzzle: Marker2D = $WeaponPivot/Muzzle

@onready var idle_sprite: Sprite2D = $IdleSprite
@onready var aim_sprite: Sprite2D = $AimSprite

var facing_dir: Vector2 = Vector2.RIGHT
var fire_cooldown: float = 0.0

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	_handle_move()
	_handle_fire(delta)
	_handle_aim()
	_handle_fire(delta)

func _handle_move() -> void:
	var move_dir := InputRouter.get_move_vector(control_scheme, joy_id)
	velocity = move_dir * move_speed
	move_and_slide()

func _handle_aim() -> void:
	var aim_dir := InputRouter.get_aim_vector(self, control_scheme, joy_id)
	if aim_dir != Vector2.ZERO:
		facing_dir = aim_dir
		rotation = facing_dir.angle()

	var is_aiming := InputRouter.is_aim_pressed(control_scheme, joy_id) \
		or InputRouter.is_fire_pressed(control_scheme, joy_id)

	_update_sprite_state(is_aiming)

func _handle_fire(delta: float) -> void:
	fire_cooldown = maxf(0.0, fire_cooldown - delta)

	if fire_cooldown > 0.0:
		return

	if not InputRouter.is_fire_pressed(control_scheme, joy_id):
		return

	fire_cooldown = fire_interval
	_shoot()

func _shoot() -> void:
	if bullet_scene == null:
		push_warning("No hay bullet_scene asignada en Player.")
		return


	var bullet := bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.rotation = facing_dir.angle()

	if bullet.has_method("setup"):
		bullet.setup(facing_dir)

	get_tree().current_scene.add_child(bullet)
	


func _update_sprite_state(is_aiming: bool) -> void:
	idle_sprite.visible = not is_aiming
	aim_sprite.visible = is_aiming
	
