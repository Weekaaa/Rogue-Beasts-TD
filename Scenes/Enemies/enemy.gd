extends PathFollow2D
class_name EnemyTemplate

var coins_dropped: int
var path_coefficient: float = 2.36 #divide by this coeff if following the forest path
var can_get_hit: bool = true
var can_shader: bool = true
var follows_main_path: bool = true
@export var health: int
@export var progress_speed: float 

func _process(delta):
	progress_ratio += progress_speed * delta

func _physics_process(_delta):
	if follows_main_path:
		if progress_ratio < 0.07 and progress_ratio >= 0.0:
			$AnimationPlayer.play("RunLeft")
		if progress_ratio < 0.17 and progress_ratio >= 0.07:
			$AnimationPlayer.play("RunUp")
		if progress_ratio < 0.22 and progress_ratio >= 0.17:
			$AnimationPlayer.play("RunLeft")
		if progress_ratio < 0.33 and progress_ratio >= 0.22:
			$AnimationPlayer.play("RunDown")
		if progress_ratio < 0.56 and progress_ratio >= 0.33:
			$AnimationPlayer.play("RunLeft")
		if progress_ratio < 0.67 and progress_ratio >= 0.56:
			$AnimationPlayer.play("RunDown")
		if progress_ratio < 0.95 and progress_ratio >= 0.67:
			$AnimationPlayer.play("RunRight")
		if progress_ratio < 1.0 and progress_ratio >= 0.95:
			$AnimationPlayer.play("RunDown")
	elif !follows_main_path:
		if progress_ratio < 0.18 and progress_ratio >= 0.0:
			$AnimationPlayer.play("RunUp")
		if progress_ratio < 0.91 and progress_ratio >= 0.18:
			$AnimationPlayer.play("RunRight")
		if progress_ratio < 1.0 and progress_ratio >= 0.91:
			$AnimationPlayer.play("RunDown")
	if progress_ratio >= 1.0:
		Globals.player_health -= health
		queue_free()

func got_hit(dmg: int):
	if can_get_hit:
		health -= dmg
		can_get_hit = false
		$Timers/AttackCooldown.start()
		play_shader()
	if health <= 0:
		$CharacterBody2D.set_collision_layer_value(2, 0) #removes from hitbox player so it is not hit by towers
		Globals.coins += coins_dropped
		play_death()

func _on_attack_cooldown_timeout():
	can_get_hit = true

func set_ShaderTimer():
	$Timers/ShaderCooldown.start()
	await $Timers/ShaderCooldown.timeout
	$Image.material.set_shader_parameter("progress", 0)
	can_shader = true

func play_shader():
	if can_shader:
		$Image.material.set_shader_parameter("progress", 1)
		can_shader = false
		set_ShaderTimer()

func play_death():
	progress_speed = 0
	$Particles.emitting = true
	$Image.visible = false
	await get_tree().create_timer(1.2).timeout
	queue_free()
