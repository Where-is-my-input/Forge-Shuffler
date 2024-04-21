extends Node2D

@onready var enemies = $GameScene/Enemies
@onready var player = $GameScene/Player
@onready var floor_number = $GameScene/lblFloor/floorNumber
@onready var game_over_menu = $GameOverMenu
@onready var lbl_floor_record = $GameScene/lblRecord/lblFloorRecord
@onready var game_scene = $GameScene
@onready var forge = $Forge
@onready var game_over_audio_0 = $GameOverMenu/gameOverAudio0
@onready var game_over_audio_1 = $GameOverMenu/GameOverAudio1
@onready var background_song = $BackgroundSong
@onready var timer_floor_end = $timerFloorEnd
@onready var timer_game_over = $timerGameOver
@onready var background = $GameScene/background
@onready var timer_screen_shake = $timerScreenShake

var floor = 0
var floorRecord = floor
var flGameOver = false
var backgroundPosition

var backGroundShakes = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	backgroundPosition = background.position
	background_song.play()
	Global.cardAction.connect(cardAction)
	Global.enemyAction.connect(enemyAction)
	Global.enemyDead.connect(startFloorEndTimer)
	Global.gameOver.connect(startGameOverTimer)
	enemies.newEnemy()
	game_over_menu.visible = false
	updateHUD()

func cardAction(card):
	if card.buffActive:
		match card.buffType:
			0: player.getBlock((card.lvl / card.lvlThreshold))
			1: player.getMaxHP((card.lvl / card.lvlThreshold))
			2: player.lowerBleeding((card.lvl / card.lvlThreshold))
	var multiplier = 1
	player.endTurn()
	if card.type == 0:
		enemies.getHit(card.atk)
	elif card.type == 2:
		enemies.getHit(card.atk, 1)
	elif card.type == 3:
		player.getBlock(card.atk, true)
	else:
		if enemies.getType() == 0:
			match enemies.getTypeVariation():
				0: multiplier = 0.7
				1: multiplier = 0.5
				2: multiplier = 0.2
		enemies.heal(card.atk * (1 - multiplier))
		player.heal(card.atk * multiplier)
	enemies.playTurn()

func enemyAction(enemy):
	var bleeding = false
	var blockBreak = false
	var damage = enemy.atk
	match enemy.type:
		0:
			damage = randi_range(damage - 2, damage + 7)
		1:
			damage = randi_range(damage - 2, damage + 1)
		2:
			damage = randi_range(damage - 5, damage + 5)
			match enemy.typeVariation:
				0: bleeding = damage > enemy.atk + 2
				1: bleeding = damage > enemy.atk
				2: bleeding = damage > enemy.atk - 2
		3:
			damage = randi_range(damage - 3, damage + 3)
			match enemy.typeVariation:
				0: blockBreak = damage > enemy.atk + 2
				1: blockBreak = damage > enemy.atk
				2: blockBreak = damage > enemy.atk - 5
			
	if player.getHit(damage, blockBreak, bleeding):
		startTimerScreenShake()
	if !flGameOver && enemy.currentHP > 0:
		player.startTurn()

func startTimerScreenShake():
	backGroundShakes = 10
	timer_screen_shake.start(0.1)

func endFloor(flForge = true):
	stopFloorEndTimer()
	enemies.die()
	player.endFloor()
	floor += 1
	player.getOre(floor)
	if floor > floorRecord:
		floorRecord = floor
	updateHUD()
	if flForge:
		openForge()

func startFloorEndTimer():
	timer_floor_end.start(3)

func stopFloorEndTimer():
	timer_floor_end.stop()
	
func startFloor():
	game_scene.visible = true
	enemies.newEnemy()
	player.draw(3)

func updateHUD():
	floor_number.text = str(floor)
	lbl_floor_record.text = str(floorRecord)

func gameOver():
	game_over_menu.visible = true
	game_scene.visible = false
	match randi_range(0,1):
		0: game_over_audio_0.play()
		1: game_over_audio_1.play()

func _on_btn_restart_pressed():
	floor = -1
	endFloor(false)
	flGameOver = false
	game_over_menu.visible = false
	enemies.restart()
	player.restart()
	game_scene.visible = true

#func _on_btn_forge_pressed():
	#openForge()

func openForge():
	game_scene.visible = false
	game_over_menu.visible = false
	forge.visible = true
	forge.viewCards(player.getDeckCards())

func closeForge():
	forge.visible = false
	player.hideCards()

func continueGameScene():
	closeForge()
	startFloor()

func _on_timer_floor_end_timeout():
	endFloor(true)

func startGameOverTimer():
	flGameOver = true
	timer_game_over.start(5)

func _on_timer_game_over_timeout():
	timer_game_over.stop()
	if flGameOver:
		gameOver()

func _on_btn_main_menu_pressed():
	var mainMenuScene = "res://Scenes/main_menu.tscn"
	get_tree().change_scene_to_file(mainMenuScene)

func _on_background_song_finished():
	background_song.play()

func _on_timer_screen_shake_timeout():
	if backGroundShakes <= 0:
		background.position = backgroundPosition
		timer_screen_shake.stop()
		return
	var pos = Vector2(10, 10)
	if backGroundShakes % 2 == 0:
		pos = Vector2(-10, -10)
	background.position += pos
	backGroundShakes -= 1
