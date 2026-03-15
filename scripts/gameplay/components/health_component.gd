extends Node
class_name HealthComponent

signal health_changed(current: int, max_health: int)
signal died
signal damaged(amount: int)
signal healed(amount: int)

@export var max_health: int = 100

var current_health: int

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func damage(amount: int) -> void:
	if amount <= 0:
		return

	current_health = max(0, current_health - amount)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)

	if current_health == 0:
		died.emit()

func heal(amount: int) -> void:
	if amount <= 0:
		return

	current_health = min(max_health, current_health + amount)
	healed.emit(amount)
	health_changed.emit(current_health, max_health)

func reset_full() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)
