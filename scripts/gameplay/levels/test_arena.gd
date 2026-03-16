extends Node2D

@onready var player = $Player
@onready var player_hud: CanvasLayer = $PlayerHud

func _ready() -> void:
	player_hud.setup(player, "P1")
