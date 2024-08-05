extends EnemyTemplate

func _ready():
	health = 500
	progress_speed = 0.015

func _physics_process(_delta):
	if progress_ratio >= 1.0:
		Globals.player_health -= health
		queue_free()

func got_hit(dmg: int):
	if can_get_hit:
		health -= dmg
		$HealthBar.value = health
		can_get_hit = false
		$Timers/AttackCooldown.start()
	if health <= 0:
		$CharacterBody2D.set_collision_layer_value(2, 0) #removes from hitbox player so it is not hit by towers
		play_death()

func play_death():
	$AnimationPlayer.play("death")
	progress_speed = 0
	await get_tree().create_timer(6).timeout
	Globals.game_complete = true
	queue_free()

func play_death_particles():
	$Particles.emitting = true
