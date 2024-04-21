extends Node2D

var defaultZ = z_index

var type = 0
var atk = 2
var lvl = 1
var lvlThreshold = 3
var buffType = 0 #Block, MaxHP, healBleed
var buffActive = false

@onready var button = $Button
@onready var text_edit = $TextEdit
@onready var card_sprite = $cardSprite
@onready var lbl_buff = $lblBuff
@onready var lbl_buff_level = $lblBuffLevel
@onready var lbl_lvl = $lblLvl
@onready var aud_forging = $ForgingSounds/audForging
@onready var aud_forging_2 = $ForgingSounds/audForging2
@onready var aud_forging_3 = $ForgingSounds/audForging3
@onready var aud_forging_4 = $ForgingSounds/audForging4

var state = 0

func _ready():
	button.visible = false
	lbl_buff.visible = false
	lbl_buff_level.visible = false
	setSprite()

func setAtributes(t, a):
	if a == 0:
		a = 1
	atk = a
	type = t
	buffType = randi_range(0, 2)
	lvlThreshold = randi_range(atk, atk * 2) + 1

func setSprite():
	match type:
		0: card_sprite.animation = "attack"
		1: card_sprite.animation = "heal"
		2: card_sprite.animation = "magic"
		3: card_sprite.animation = "block"

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && !event.pressed && state > 0:
		get_parent().cardAction(self)

func removeParent():
	get_parent().remove_child(self)

func generate(roll):
	setAtributes(randi_range(0, 3), randi_range(roll / 2, roll))

func removeFromPlay():
	visible = false
	state = 0

func addToHand(position):
	z_index = defaultZ
	global_position = position
	state = 1
	visible = true
	updateHUD()

func updateHUD():
	#if state > 0:
	text_edit.text = str(atk)
	lbl_lvl.text = str(lvl)

func view(position, flForge = false):
	z_index = 10
	global_position = position
	visible = true
	if flForge:
		button.visible = true
	updateHUD()

func hideCard():
	button.visible = false
	visible = false

func _on_button_pressed():
	if Global.ores > 0:
		playForgingSfx()
		lvl += 1
		if lvl % lvlThreshold == 0:
			activateBuff()
		Global.ores -= 1
		atk += 1
		Global.oreSpent.emit()
		updateHUD()

func playForgingSfx():
	match randi_range(0,3):
		0: aud_forging.play()
		1: aud_forging_2.play()
		2: aud_forging_3.play()
		3: aud_forging_4.play()

func activateBuff(): #Block, MaxHP, healBleed
	buffActive = true
	lbl_buff.visible = true
	lbl_buff_level.visible = true
	match buffType:
		0: lbl_buff.text = str("+Block")
		1: lbl_buff.text = str("+MaxHP")
		2: lbl_buff.text = str("-Bleed")
	lbl_buff_level.text = str("Lvl", (lvl / lvlThreshold))
