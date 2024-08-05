extends LevelTemplate

signal game_won

const cyan: Color = Color("00f3f3", 0.5)
const red: Color = Color("ea0a0a", 0.5)

const close_up_cam_zoom: Vector2 = Vector2(4.1, 4.1)
const enemy_cam_zoom: Vector2 = Vector2(5.2, 5.2)
const full_view_cam_zoom: Vector2 = Vector2(1.41, 1.445)

const start_view_cam_pos: Vector2 = Vector2(15.0, 460.0)
const full_view_cam_pos: Vector2 = Vector2(408.795, 224.29)
const bimo_cam_pos: Vector2 = Vector2(250.0, 250.0)

var place_area_shown: bool = true
var tower_to_place = null
var placing_tower: bool = false

var blue_samurai_scene: PackedScene = preload("res://Scenes/Towers/samurai_blue.tscn")
var fighter_red_scene: PackedScene = preload("res://Scenes/Towers/fighter_red.tscn")
var ninja_red_2_scene: PackedScene = preload("res://Scenes/Towers/ninja_red_2.tscn")

var slime2_scene: PackedScene = preload("res://Scenes/Enemies/Plains/slime2.tscn")
var cyclope2_scene: PackedScene = preload("res://Scenes/Enemies/Plains/cyclope2.tscn")
var slime4_scene: PackedScene = preload("res://Scenes/Enemies/Plains/slime4.tscn")
var reptile2_scene: PackedScene = preload("res://Scenes/Enemies/Plains/reptile2.tscn")
var bamboo_scene: PackedScene = preload("res://Scenes/Enemies/Plains/bamboo.tscn")
var snake2_scene: PackedScene = preload("res://Scenes/Enemies/Plains/snake2.tscn")
var cyclope_boss_scene: PackedScene = preload("res://Scenes/Enemies/Plains/cyclope_boss.tscn")

@onready var slime4_timer: Timer = %Slime4Spawn
@onready var cyclope2_timer: Timer = %Cyclope2Spawn
@onready var snake2_timer: Timer = %Snake2Spawn
@onready var reptile2_timer: Timer = %Reptile2Spawn
@onready var bamboo_timer: Timer = %BambooSpawn
@onready var slime2_timer: Timer = %Slime2Spawn

func _ready():
	$Camera.position = start_view_cam_pos
	$Camera/Camera2D.zoom = close_up_cam_zoom
	Engine.time_scale = 1
	
	#await get_tree().create_timer(10).timeout
	#$Ground/StartArrows.visible = true
	#$Ground/EndArrows.visible = true

func _process(_delta):
	if placing_tower: #checks if a tower is being placed
		var mouse_pos = get_global_mouse_position()
		if Globals.can_place_tower:
			tower_to_place.get_child(2).modulate = cyan
		else:
			tower_to_place.get_child(2).modulate = red
		tower_to_place.global_position = mouse_pos #makes the tower to be placed follow the mouse
		if Input.is_action_just_pressed("ui_select"): #proceed when left click
			place_tower() 
		elif Input.is_action_just_pressed("ui_cancel"): #proceed when right click
			cancel_place_tower()
	
	if Globals.wave_active: #checks to see if a wave is cleared
		if $Paths/MainPath.get_child_count() == 0: 
			Globals.wave_active = false
			$Sounds/RoundWon.play()
			await get_tree().create_timer(0.8).timeout
			get_wave_clear_reward(Globals.current_wave_number)
			$Sounds/Coins.play()
			#Globals.game_complete = true

func main_path_cam(cam_move_speed: float):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera/Camera2D, "zoom", enemy_cam_zoom, 0.5)
	tween.tween_property($Camera, "position", Vector2(712.0, 229.0), 0.5)
	tween.set_parallel(false)
	tween.tween_property($Camera, "position", Vector2(704.0, 224.0), cam_move_speed)
	tween.tween_property($Camera, "position", Vector2(694.0, 221.0), cam_move_speed)
	tween.tween_property($Camera, "position", Vector2(671.0, 218.0), cam_move_speed)
	tween.tween_property($Camera, "position", Vector2(653.0, 209.0), cam_move_speed * 0.75)
	tween.tween_property($Camera, "position", Vector2(641.0, 199.0), cam_move_speed * 0.75)
	tween.set_parallel(true)
	tween.tween_property($Camera, "position", full_view_cam_pos, (cam_move_speed + 0.05))
	tween.tween_property($Camera/Camera2D, "zoom", full_view_cam_zoom, (cam_move_speed + 0.05))

func forest_path_cam(cam_move_speed: float):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera/Camera2D, "zoom", enemy_cam_zoom, 0.6)
	tween.tween_property($Camera, "position", Vector2(50.0, 433.0), 0.6)
	tween.set_parallel(false)
	tween.tween_property($Camera, "position", Vector2(71.0, 419.0), cam_move_speed)
	tween.tween_property($Camera, "position", Vector2(90.0, 400.0), cam_move_speed)
	tween.tween_property($Camera, "position", Vector2(101.0, 389.0), cam_move_speed)
	tween.set_parallel(true)
	tween.tween_property($Camera, "position", full_view_cam_pos, (cam_move_speed + 0.05))
	tween.tween_property($Camera/Camera2D, "zoom", full_view_cam_zoom, (cam_move_speed + 0.05))

func bimo_cam():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera, 'position', bimo_cam_pos, 0.5)
	tween.tween_property($Camera/Camera2D, 'zoom', close_up_cam_zoom, 0.5)

func spawn_next_wave(wave_number: int):
	match wave_number:
		1:
			_spawn_wave_one()
			await get_tree().create_timer(2.5).timeout
			$Ground/StartArrows.visible = false
			$Ground/EndArrows.visible = false
		2:
			_spawn_wave_two()
		3:
			_spawn_wave_three()
		4:
			_spawn_wave_four()
		5:
			_spawn_wave_five()
		6:
			_spawn_wave_six()
		7:
			_spawn_wave_seven()
		8:
			_spawn_wave_eight()
		9:
			_spawn_wave_nine()
		10:
			_spawn_wave_ten()

#introduces the slime
func _spawn_wave_one(): # 50 THP, 25 TCD
	spawn_enemy(slime2_scene, 5, slime2_timer, true)
	main_path_cam(1)

func _spawn_wave_two(): # 100 THP, 50 TCD
	spawn_enemy(slime2_scene, 10, slime2_timer, true)

#introduces the cyclope
func _spawn_wave_three(): # 180 THP, 80 TCD
	spawn_enemy(cyclope2_scene, 5, cyclope2_timer, true)
	main_path_cam(1.1)
	await set_GroupTimer(8)
	spawn_enemy(slime2_scene, 8, slime2_timer, true)

#introduces the mature slime
func _spawn_wave_four(): # 160 THP , 80 TCD
	spawn_enemy(slime4_scene, 8, slime4_timer, true)
	main_path_cam(0.9)

#introduces the young snake
func _spawn_wave_five(): # 116 THP, 70 TCD
	spawn_enemy(snake2_scene, 8, snake2_timer, true)
	main_path_cam(0.5)
	await set_GroupTimer(4)
	spawn_enemy(slime4_scene, 3, slime4_timer, true)

#introduces the reptile
func _spawn_wave_six(): # 315 THP , 105 TCD
	spawn_enemy(slime2_scene, 7, slime2_timer, true)
	await set_GroupTimer(8)
	main_path_cam(1.2)
	spawn_enemy(reptile2_scene, 8, reptile2_timer, true)

func _spawn_wave_seven(): # 400 THP , 200 TCD
	spawn_enemy(slime4_scene, 10, slime4_timer, true)
	await set_GroupTimer(9)
	spawn_enemy(slime2_scene, 20, slime2_timer, true)

#introduces the bamboo
func _spawn_wave_eight(): # 352 THP , 190 TCD
	bimo_cam()
	spawn_enemy(cyclope2_scene, 5, cyclope2_timer, true)
	$Ground/MegaAlertIcon.visible = true
	await set_GroupTimer(4)
	$Ground/MegaAlertIcon.visible = false
	forest_path_cam(1)
	spawn_enemy(bamboo_scene, 10, bamboo_timer, false)
	await set_GroupTimer(9)
	spawn_enemy(snake2_scene, 10, snake2_timer, true)
	await set_GroupTimer(16)
	spawn_enemy(snake2_scene, 6, snake2_timer, false)

func _spawn_wave_nine(): # 1,135 THP , 454 TCD
	spawn_enemy(bamboo_scene, 12, bamboo_timer, false)
	spawn_enemy(cyclope2_scene, 8, cyclope2_timer, true)
	await set_GroupTimer(14)
	spawn_enemy(reptile2_scene, 6, reptile2_timer, false)
	await set_GroupTimer(6)
	spawn_enemy(reptile2_scene, 9, reptile2_timer, true)
	await set_GroupTimer(12)
	spawn_enemy(snake2_scene, 6, snake2_timer, true)
	spawn_enemy(snake2_scene, 4, snake2_timer, false)
	await set_GroupTimer(5)
	spawn_enemy(slime4_scene, 5, slime4_timer, true)
	spawn_enemy(bamboo_scene, 8, bamboo_timer, false)

func _spawn_wave_ten():
	var boss = cyclope_boss_scene.instantiate() as EnemyTemplate
	boss.rotation_degrees = 0
	$Paths/BossPath.add_child(boss)

func get_wave_clear_reward(wave_number: int):
	match wave_number: #starts from 2 since wave num is incremented at end of each wave
		2:
			Globals.coins += 60
		3:
			Globals.coins += 70
		4:
			Globals.coins += 80
		5:
			Globals.coins += 50
		6:
			Globals.coins += 50
		7:
			Globals.coins += 50
		8:
			Globals.coins += 50
		9:
			Globals.coins += 20
		10:
			Globals.coins += 20
		_:
			return

func spawn_enemy(enemy_scene: PackedScene, enemy_count: int, enemy_timer: Timer, main_path: bool):
	for i in range(enemy_count): #repeats for number of enemies to be spawned
		var enemy = enemy_scene.instantiate() as EnemyTemplate #creates the enemy
		enemy.rotation_degrees = 0 #for some reason the rotation is messed up, so it needs to be reset
		if main_path: #proceeds if the enemy is to be spawned on the main path
			$Paths/MainPath.add_child(enemy)
			enemy.follows_main_path = true
		elif !main_path: #proceeds if the enemy is to be spawned on the forest path
			$Paths/ForestPath.add_child(enemy)
			enemy.follows_main_path = false
			enemy.progress_speed *= enemy.path_coefficient #make the enemy speed adjust to shorter path                                         
		enemy_timer.start() #spaces out the enemies so they dont spawn close to eachother 
		await enemy_timer.timeout #same as above

func start_place_tower(tower: PackedScene): #shows pos to place tower
	if tower == blue_samurai_scene and Globals.coins >= 100:
		formulate_tower(tower)
	if tower == fighter_red_scene and Globals.coins >= 225:
		formulate_tower(tower)
	if tower == ninja_red_2_scene and Globals.coins >= 175:
		formulate_tower(tower)

func place_tower(): #places tower at pos shown by start_place_tower fn
	if Globals.can_place_tower:
		Globals.coins -= tower_to_place.tower_cost #spends player's coins
		$CanvasLayer.update_coins_text() #sets new coin count
		tower_to_place.modulate.a = 1.0 #makes the tower opaque
		tower_to_place.get_child(2).visible = false
		connect_projectile_signal() #connects the signal related to the tower
		placing_tower = false #notifies the process fn that a tower is no longer being placed
		tower_to_place = null #clears the tower to place
		$Sounds/TowerPlace.play()
		if !Globals.first_tower_placed:
			$Ground/AlertIcon.visible = false
			Globals.first_tower_placed = true
	else:
		cancel_place_tower()

func cancel_place_tower(): #cancels the placement of a tower
	tower_to_place.queue_free() #removes the child from tower node
	placing_tower = false #notifies the process fn that a tower is no longer being placed
	tower_to_place = null #clears the tower to place

func formulate_tower(tower: PackedScene):
	tower_to_place = tower.instantiate() as TowerTemplate #creates the tower
	tower_to_place.modulate.a = 0.5 #makes the tower semi-transparent
	$Towers.add_child(tower_to_place) 
	placing_tower = true #notifies the process fn that a tower is being placed

func connect_projectile_signal():
	if tower_to_place in get_tree().get_nodes_in_group("SamuraiBlues"):
		tower_to_place.connect("shuriken", _on_tower_shuriken) #allow the tower to throw shurikens
	if tower_to_place in get_tree().get_nodes_in_group("FighterReds"):
		tower_to_place.connect("kunai", _on_tower_kunai) #allow the tower to throw kunais
	if tower_to_place in get_tree().get_nodes_in_group("NinjaRed2s"):
		tower_to_place.connect("sai", _on_tower_sai) #allow the tower to throw sais

func set_WaveTimer(time: int):
	%WaveTimer.wait_time = time
	%WaveTimer.start()
	await %WaveTimer.timeout

func set_GroupTimer(time: int):
	%GroupTimer.wait_time = time
	%GroupTimer.start()
	await %GroupTimer.timeout

func _on_canvas_layer_blue_samurai_picked():
	start_place_tower(blue_samurai_scene)

func _on_canvas_layer_fighter_red_picked():
	start_place_tower(fighter_red_scene)

func _on_canvas_layer_ninja_red_2_picked():
	start_place_tower(ninja_red_2_scene)

func _on_canvas_layer_spawn_next_wave():
	spawn_next_wave(Globals.current_wave_number)
	Globals.wave_active = true
	Globals.current_wave_number += 1
	$Sounds/NextRound.play()

func _on_place_zones_body_entered(_body):
	Globals.can_place_tower = true

func _on_place_zones_body_exited(_body):
	Globals.can_place_tower = false

func _on_canvas_layer_restart_game():
	get_tree().reload_current_scene()

func _on_canvas_layer_game_start(): #emit when 'start' option is picked from start menu
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera, 'position', bimo_cam_pos, 1.0)
	tween.tween_property($Camera/Camera2D, 'zoom', close_up_cam_zoom, 1.0)
	$Ground/AlertIcon.visible = true
	tween.chain().tween_property($Camera, 'position', bimo_cam_pos, 5.0)
	tween.set_parallel(false)
	tween.tween_property($Camera, 'position', Vector2(584, 121), 1.0)
	tween.parallel().tween_property($Camera/Camera2D, 'zoom', enemy_cam_zoom, 1.0)
