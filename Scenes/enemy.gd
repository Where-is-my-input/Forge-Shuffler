extends Node2D

const FADE_OUT_COLOR = Color(0,0,0,1)
const FADE_IN_COLOR = Color(0,0,0,0)

@onready var hp = $HP
@onready var enemies = $".."
@onready var text_edit = $TextEdit
@onready var sprite_2d = $Sprite2D
@onready var hp_label = $HP/hpLabel
@onready var animation_player = $AnimationPlayer
@onready var damaged = $AnimationPlayer/damaged
@onready var lbl_damage_taken = $lblDamageTaken
@onready var timer_damage_taken = $lblDamageTaken/timerDamageTaken
@onready var timer_fadeout = $timerFadeout
@onready var lbl_heal = $lblHeal
@onready var timer_flash = $timerFlash
@onready var sfx = $sfx

var maxHP = 10
var currentHP = maxHP

var atk = 1
var type = 0
var typeVariation = 0

var flashing = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#hp.max_value = maxHP
	lbl_heal.visible = false
	damaged.visible = false
	lbl_damage_taken.visible = false
	updateHud()

func getHit(value, damageType = 0):
	timer_flash.start(0.1)
	flashing = 6
	animation_player.play("getHit")
	damaged.visible = true
	if damageType == 1 && type == 1:
		match typeVariation:
			0: value = value *1.5
			1: value = value *2
			2: value = value *2.5
	currentHP -= floor(value)
	lbl_damage_taken.text = str("-",floor(value))
	lbl_damage_taken.visible = true
	timer_damage_taken.start(10)
	updateHud()
	sfx.playGetHit()
	if currentHP <= 0:
		currentHP = 0
		updateHud()
		die()

func updateHud():
	text_edit.text = str(atk)
	hp.max_value = maxHP
	hp.value = currentHP
	hp_label.text = str(currentHP, "/", maxHP)

func die():
	#enemies.newEnemy()
	Global.enemyDead.emit()
	timer_fadeout.start(0.1)

func playTurn():
	if currentHP > 0:
		Global.enemyAction.emit(self)

func generate(value, floor):
	atk = value + 1
	type = randi_range(0,3)
	typeVariation = randi_range(0,2)
	maxHP = randi_range(value-5, value + (5*floor)) +10
	if maxHP <= 0:
		maxHP = 1
	currentHP = maxHP
	match type:
		0:
			selectChupaCuAnimation(typeVariation)
		1:
			selectGreatoDoggoAnimation(typeVariation)
		2:
			selectSamaraAnimation(typeVariation)
		3:
			selectOrcAnimation(typeVariation)
	updateHud()

func selectChupaCuAnimation(v):
	match v:
		0: sprite_2d.animation = "ChupaCu"
		1: sprite_2d.animation = "ChupaCu2"
		2: sprite_2d.animation = "ChupaCu3"

func selectGreatoDoggoAnimation(v):
	match v:
		0: sprite_2d.animation = "GreatoDoggo"
		1: sprite_2d.animation = "GreatoDoggo2"
		2: sprite_2d.animation = "GreatoDoggo3"
	
func selectSamaraAnimation(v):
	match v:
		0: sprite_2d.animation = "Samara"
		1: sprite_2d.animation = "Samara2"
		2: sprite_2d.animation = "Samara3"
	
func selectOrcAnimation(v):
	match v:
		0: sprite_2d.animation = "Orc0"
		1: sprite_2d.animation = "Orc2"
		2: sprite_2d.animation = "Orc3"

func getType():
	return type

func getTypeVariation():
	return typeVariation

func heal(value):
	currentHP += floor(value)
	if currentHP > maxHP:
		currentHP = maxHP
	if floor(value) > 0:
		lbl_heal.text = str("+",floor(value))
		lbl_heal.visible = true
	updateHud()

func _on_animation_player_animation_finished(anim_name):
	animation_player.play("none")
	damaged.visible = false
	lbl_heal.visible = false

func _on_timer_damage_taken_timeout():
	lbl_damage_taken.visible = false

func _on_timer_fadeout_timeout():
	sprite_2d.modulate.a -= 0.05
	timer_fadeout.start(0.1)


func _on_timer_flash_timeout():
	if flashing <= 0:
		sprite_2d.modulate.a = 1
		timer_flash.stop()
		return
	if flashing % 2 == 0:
		sprite_2d.modulate.a = 0
	else:
		sprite_2d.modulate.a = 1
	flashing -= 1
