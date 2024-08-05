extends Node2D
class_name LevelTemplate

var shuriken_scene: PackedScene = preload("res://Scenes/Projectiles/shuriken.tscn")
var kunai_scene: PackedScene = preload("res://Scenes/Projectiles/kunai.tscn")
var sai_scene: PackedScene = preload("res://Scenes/Projectiles/sai.tscn")

func create_shuriken(pos, direction):
	var shuriken = shuriken_scene.instantiate() as Area2D
	shuriken.position = pos
	shuriken.direction = direction
	$Projectiles.add_child(shuriken)

func create_kunai(pos, direction):
	var kunai = kunai_scene.instantiate() as Area2D
	kunai.position = pos
	kunai.direction = direction
	kunai.rotation_degrees = rad_to_deg(direction.angle()) + 90
	$Projectiles.add_child(kunai)

func create_sai(pos, direction):
	var sai = sai_scene.instantiate() as Area2D
	sai.position = pos
	sai.direction = direction
	sai.rotation_degrees = rad_to_deg(direction.angle()) + 90
	$Projectiles.add_child(sai)

func _on_tower_shuriken(pos, direction):
	create_shuriken(pos, direction)

func _on_tower_kunai(pos, direction):
	create_kunai(pos, direction)

func _on_tower_sai(pos, direction):
	create_sai(pos, direction)
