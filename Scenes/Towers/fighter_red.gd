extends TowerTemplate

var alternate: bool = true

signal kunai(pos, direction)

func _ready():
	tower_cost = 225
	attack_cd = 1
	$Timers/AttackTimer.wait_time = attack_cd
	attack_dmg = 6

func _process(_delta):
	update_progress_ratio()
	if current_target != null:
		if can_attack and enemy_attackable[current_target] == true:
			var kunai_marker = $ProjectileSpawns.get_child(alternate) #chooses kunai spawn location
			alternate = not alternate #alternates between both spawn locations
			var pos: Vector2 = kunai_marker.global_position
			var direction: Vector2 = (current_target.global_position - position).normalized()
			kunai.emit(pos, direction)
			can_attack = false
			$Timers/AttackTimer.start()
