extends TowerTemplate

signal shuriken(pos, direction)

func _ready():
	tower_cost = 100
	attack_cd = 2
	$Timers/AttackTimer.wait_time = attack_cd
	attack_dmg = 5

func _process(_delta):
	update_progress_ratio()
	if current_target != null:
		if can_attack and enemy_attackable[current_target] == true:
			var shuriken_marker = $ProjectileSpawns.get_child(0) #chooses shuriken spawn location
			var pos: Vector2 = shuriken_marker.global_position 
			var direction: Vector2 = (current_target.global_position - position).normalized()
			shuriken.emit(pos, direction)
			can_attack = false
			$Timers/AttackTimer.start()
