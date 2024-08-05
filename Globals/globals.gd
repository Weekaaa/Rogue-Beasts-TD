extends Node

signal coins_change()
signal round_change()
signal player_health_change()

var coins: int = 150:
	set(value):
		coins = value
		coins_change.emit()

var player_health: int = 100:
	set(value):
		player_health = max(value, 0)
		player_health_change.emit()

var current_wave_number: int = 1:
	set(value):
		current_wave_number = min(value, 11)
		round_change.emit()

var can_place_tower: bool = false
var wave_active: bool = false
var game_complete: bool = false
var first_tower_placed: bool = false
