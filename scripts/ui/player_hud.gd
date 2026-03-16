extends CanvasLayer

@onready var player_name_label: Label = $MarginContainer/VBoxContainer/PlayerNameLabel
@onready var health_bar: TextureProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthLabel
@onready var ammo_label: Label = $MarginContainer/VBoxContainer/AmmoLabel

var player: Node = null
var health_component: Node = null

func setup(player_node: Node, player_name: String) -> void:
	player = player_node
	player_name_label.text = player_name

	health_component = player.get_node("HealthComponent")
	if health_component == null:
		push_warning("PlayerHUD: no se encontró HealthComponent.")
		return

	if health_component.has_signal("health_changed"):
		health_component.health_changed.connect(_on_health_changed)

	if player.has_signal("ammo_changed"):
		player.ammo_changed.connect(_on_ammo_changed)

	_on_health_changed(health_component.current_health, health_component.max_health)
	_on_ammo_changed(player.current_ammo, player.max_ammo)

func _on_health_changed(current: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current
	health_label.text = "VIDA: %d / %d" % [current, max_health]

func _on_ammo_changed(current: int, max_ammo: int) -> void:
	ammo_label.text = "BALAS: %d / %d" % [current, max_ammo]
