extends CanvasLayer

signal blue_samurai_picked #notifies the game that the samurai has been chosen
signal fighter_red_picked #notifies the game that the fighter has been chosen
signal ninja_red_2_picked #notifies the game that the red ninja has been chosen
signal spawn_next_wave #spawns the next wave
signal restart_game #restarts the game after losing
signal game_start #notifies the game that it has started (shift cam pos)

var current_time_scale: float
var slime_described: bool = true
var cyclope_described: bool = true
var matured_slime_described: bool = true
var young_snake_described: bool = true
var reptile_described: bool = true
var bamboo_described: bool = true
var cyclope_queen_described: bool = true
var tutorial_started: bool = true
var tutorial2_started: bool = true
var path_tip: bool = true
var one_time: bool = true
var ingame: bool = false #active when player starts game
var can_open_pause_menu: bool = false #controls when the player can open the pause menu
var pause_menu_open: bool = false

@onready var player_health_count: Label = %Health
@onready var coin_count: Label = %CoinCount

func _ready():
	%SpawnWaveButton.disabled = true
	Globals.connect('player_health_change', player_health_update)
	Globals.connect('coins_change', coins_update)
	Globals.connect('round_change', round_number_update)
	update_coins_text()

func _process(_delta):
	if Globals.current_wave_number >= 2:
		if Globals.wave_active:
			%SpawnWaveButton.disabled = true
		else:
			%SpawnWaveButton.disabled = false
	
	if Globals.game_complete:
		on_game_won()
		Globals.game_complete = false
	
	if ingame:
		play_dialogue()
		if can_open_pause_menu:
			if Input.is_action_just_pressed("ui_close_window"):
				current_time_scale = Engine.time_scale
				Engine.time_scale = 0
				$PauseMenu.visible = true
				pause_menu_open = true
				can_open_pause_menu = false
				await get_tree().create_timer(1).timeout
		if pause_menu_open:
			if Input.is_action_just_pressed("ui_close_window"):
				Engine.time_scale = current_time_scale
				$PauseMenu.visible = false
				pause_menu_open = false
				can_open_pause_menu = true
				await get_tree().create_timer(1).timeout

#========================================================#
#--------------------DIALOGUE-LOGIC----------------------#
#========================================================#

func play_dialogue():
	if Globals.current_wave_number == 1 and tutorial_started:
		tutorial_started = !tutorial_started
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%Villager.visible = true
		$Node/Alert.play()
		await display_timed_text(%VillagerWelcome, 5)
		$Node/Alert.play()
		await display_timed_text(%VillagerTipOne, 2.5)
		%Villager.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 1 and tutorial2_started:
		if Globals.first_tower_placed:
			tutorial2_started = false
			%DialogueBox.visible = true
			%Villager.visible = true
			$Node/Alert.play()
			await display_timed_text(%VillagerTipTwo, 2)
			%SpawnWaveButton.disabled = false
			%Villager.visible = false
			%DialogueBox.visible = false
			await get_tree().create_timer(10).timeout
			$Ingame/Tips.visible = true
			await display_timed_text(%ToolTips, 7)
			$Ingame/Tips.visible = false
	
	if Globals.current_wave_number == 2 and slime_described:
		slime_described = !slime_described
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%Slime.visible = true
		$Node/Alert.play()
		await display_timed_text(%SlimeStats, 3)
		$Node/Alert.play()
		await display_timed_text(%SlimeDesc, 3)
		%Slime.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 3 and path_tip:
		path_tip = !path_tip
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%Villager.visible = true
		$Node/Alert.play()
		await display_timed_text(%VillagerTipThree, 5)
		$Node/Alert.play()
		await display_timed_text(%VillagerTipFour, 5)
		%Villager.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 4 and cyclope_described:
		cyclope_described = !cyclope_described
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%Cyclope.visible = true
		$Node/Alert.play()
		await display_timed_text(%CyclopeStats, 3)
		$Node/Alert.play()
		await display_timed_text(%CyclopeDesc, 3)
		%Cyclope.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 5 and matured_slime_described:
		matured_slime_described = !matured_slime_described
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%MaturedSlime.visible = true
		$Node/Alert.play()
		await display_timed_text(%MaturedSlimeStats, 3)
		$Node/Alert.play()
		await display_timed_text(%MaturedSlimeDesc, 3)
		%MaturedSlime.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 6 and young_snake_described:
		young_snake_described = !young_snake_described
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%YoungSnake.visible = true
		$Node/Alert.play()
		await display_timed_text(%YoungSnakeStats, 3)
		$Node/Alert.play()
		await display_timed_text(%YoungSnakeDesc, 3)
		%YoungSnake.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 7 and reptile_described:
		reptile_described = !reptile_described
		await get_tree().create_timer(8).timeout
		%DialogueBox.visible = true
		%Reptile.visible = true
		$Node/Alert.play()
		await display_timed_text(%ReptileStats, 3)
		$Node/Alert.play()
		await display_timed_text(%ReptileDesc, 3)
		%Reptile.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 9 and bamboo_described:
		bamboo_described = !bamboo_described
		await get_tree().create_timer(1).timeout
		%DialogueBox.visible = true
		%Villager.visible = true
		$Node/Alert.play()
		await display_timed_text(%VillagerTipFive, 3)
		%Villager.visible = false
		%Bamboo.visible = true
		$Node/Alert.play()
		await display_timed_text(%BambooStats, 3)
		$Node/Alert.play()
		await display_timed_text(%BambooDesc, 3)
		%Bamboo.visible = false
		%DialogueBox.visible = false
	
	if Globals.current_wave_number == 11 and cyclope_queen_described:
		var tween = create_tween()
		tween.tween_property($Node/Music, 'volume_db', -50, 0.3)
		#$Node/Music.stop()
		$Node/BossMusic.play()
		cyclope_queen_described = !cyclope_queen_described
		%DialogueBox.visible = true
		%CyclopeQueen.visible = true
		await display_timed_text(%CyclopeQueenStats, 5)
		await display_timed_text(%CyclopeQueenDesc, 5)
		%CyclopeQueen.visible = false
		%DialogueBox.visible = false


func display_timed_text(text: Label, time: float):
	text.visible = true
	var tween = create_tween()
	tween.tween_property(text, "visible_ratio", 1, 1.2)
	await get_tree().create_timer(time).timeout
	text.visible = false


#========================================================#
#----------------------GAME-LOGIC------------------------#
#========================================================#

func on_game_over():
	Engine.time_scale = 0 #stops game completely
	$Node/GameOver.play()
	%BlueSamuraiButton.disabled = true
	%FighterRedButton.disabled = true
	%NinjaRed2Button.disabled = true
	%FastForwardButton.disabled = true
	%SpawnWaveButton.disabled = true
	$Ingame/LoseScreen.visible = true


func on_game_won():
	Engine.time_scale = 0
	$Node/BossMusic.stop()
	$Node/GameWon.play()
	%BlueSamuraiButton.disabled = true
	%FighterRedButton.disabled = true
	%NinjaRed2Button.disabled = true
	%FastForwardButton.disabled = true
	%SpawnWaveButton.disabled = true
	$Ingame/WinScreen.visible = true


func round_number_update():
	%RoundNumber.text = str(Globals.current_wave_number - 1) + '  /  10'


func update_player_health_text():
	player_health_count.text = str(Globals.player_health)
	$Node/HealthLost.play()
	if Globals.player_health <= 75:
		$Node/HealthLost2.play()
		%Heart.frame = 3
		if Globals.player_health <= 50:
			%Heart.frame = 2
			if Globals.player_health <= 25:
				%Heart.frame = 1
				if Globals.player_health <= 0:
					%Heart.frame = 0
					$Node/Music.stop()
					on_game_over()


func player_health_update():
	update_player_health_text()


func update_coins_text():
	coin_count.text = str(Globals.coins)


func coins_update():
	update_coins_text()


func _on_level_game_won(): #recieves signal from the plains script when game is won
	on_game_won()


func reset_game_variables():
	Globals.coins = 150
	Globals.player_health = 100
	Globals.current_wave_number = 1
	Globals.first_tower_placed = false

#========================================================#
#--------------------BUTTON-SIGNALS----------------------#
#========================================================#

func _on_spawn_wave_button_pressed():
	spawn_next_wave.emit()


func _on_restart_button_pressed():
	reset_game_variables()
	restart_game.emit()


func _on_fast_forward_button_toggled(toggled_on):
	if toggled_on:
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1


func _on_start_game_button_pressed():
	$Node/Music.play()
	game_start.emit()
	ingame = true
	can_open_pause_menu = true
	$StartMenu.visible = false
	$Ingame.visible = true


func _on_main_menu_button_pressed():
	$PauseMenu.visible = false
	$Ingame.visible = false
	$StartMenu.visible = true
	restart_game.emit()
	ingame = false
	reset_game_variables()


func _on_blue_samurai_button_pressed():
	blue_samurai_picked.emit()


func _on_fighter_red_button_pressed():
	fighter_red_picked.emit()


func _on_ninja_red_2_button_pressed():
	ninja_red_2_picked.emit()


#========================================================#
#-----------------DEBUG-BUTTONS-SIGNALS------------------#
#========================================================#

func _on_debug_win_game_button_pressed():
	on_game_won()


func _on_debug_lose_game_button_pressed():
	Globals.player_health -= 100


func _on_last_wave_button_pressed():
	$Node/Music.stop()
	Globals.current_wave_number = 10
	Globals.coins += 5000


func _on_cyclope_wave_button_pressed():
	path_tip = false
	Globals.current_wave_number = 3


func _on_mature_slime_wave_button_pressed():
	cyclope_described = false
	Globals.current_wave_number = 4


func _on_young_snake_wave_button_pressed():
	matured_slime_described = false
	Globals.current_wave_number = 5


func _on_reptile_wave_button_pressed():
	young_snake_described = false
	Globals.current_wave_number = 6


func _on_bamboo_wave_button_pressed():
	Globals.current_wave_number = 8
