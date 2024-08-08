extends Node2D
class_name TowerTemplate

var can_attack: bool = true #related to AttackTimer
var current_target #enemy which the tower is targetting
var enemies_in_attack_range = [] #An array to keep track of the enemies who have entered the tower's attack range
var enemy_attackable = {} #Keeps track of which enemy can be attacked
var tower_cost: int
@export var attack_dmg: int #attack damage
@export var attack_cd: float #cooldown between attacks, equals the attack timer wait time
@export var attack_range_radius: float  #radius of attack range circle

func _ready():
	$Timers/AttackTimer.wait_time = attack_cd

func update_progress_ratio(): #loops through all enemies that have entered the range to find the one with the most progress
	var highest_progress = -1.0 #all values are higher than this default value, prog ratio can never be below 0
	for enemy in enemies_in_attack_range:
		if enemy != null: #if removed, an error will be produced due to a "get_parent()" call on a previously freed node
			var enemy_progress = enemy.get_parent().progress_ratio
			if enemy_progress > highest_progress and enemy_attackable[enemy] == true:
				highest_progress = enemy_progress #saves the highest prog ratio
				current_target = enemy #targets the enemy with the highest prog ratio

func _on_attack_range_body_entered(body):
	enemy_attackable[body] = true #makes the enemy attackable
	enemies_in_attack_range.append(body) #the order in which bodies enter the attack range

func _on_attack_range_body_exited(body):
	enemy_attackable[body] = false #prevents the enemy from being attacked

func _on_attack_timer_timeout(): #attack cooldown
	can_attack = true

func _on_t2t_range_body_entered(_body):
	Globals.can_place_tower = false

func _on_t_2t_range_body_exited(_body):
	Globals.can_place_tower = true
