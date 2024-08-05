extends TowerTemplate

var alternate = true

signal sai(pos, direction)

func _ready():
	tower_cost = 175
	attack_cd = 1.4
	$Timers/AttackTimer.wait_time = attack_cd
	attack_dmg = 7

func _process(_delta):
	update_progress_ratio()
	if current_target != null:
		if can_attack and enemy_attackable[current_target] == true:
			var sai_marker = $ProjectileSpawns.get_child(alternate) #chooses sai spawn location
			alternate = not alternate #alternates between both spawn locations
			var pos: Vector2 = sai_marker.global_position
			var direction: Vector2 = (current_target.global_position - position).normalized()
			sai.emit(pos, direction)
			can_attack = false
			$Timers/AttackTimer.start()
