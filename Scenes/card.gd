extends Node2D

var defaultZ = z_index

var type = 0
var atk = 2
var lvl = 1
var lvlThreshold = 3
var buffType = 0 #Block, MaxHP, healBleed
var buffActive = false
var buffLevel = 0

@onready var card_btn_container = $cardBtnContainer
@onready var button = $cardBtnContainer/btnUpgrade
@onready var btn_regenerate = $cardBtnContainer/btnRegenerate
@onready var btn_buff_lvl_up = $cardBtnContainer/btnBuffLvlUp
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
var upgradePressed = false
var buffPressed = false

func _ready():
	card_btn_container.visible = false
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
	buffActive = false
	buffLevel = 0
	lvl = 1

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
		card_btn_container.visible = true
	updateHUD()

func hideCard():
	card_btn_container.visible = false
	visible = false

func _on_button_pressed():
	upgradePressed = true
	upgrade()

func upgrade():
	while upgradePressed:
		if Global.ores > 0:
			playForgingSfx()
			lvl += 1
			if lvl % lvlThreshold == 0:
				activateBuff()
			Global.ores -= 1
			atk += 1
			Global.oreSpent.emit()
			updateHUD()
		else:
			upgradePressed = false
		await get_tree().create_timer(0.09).timeout

func playForgingSfx():
	match randi_range(0,3):
		0: aud_forging.play()
		1: aud_forging_2.play()
		2: aud_forging_3.play()
		3: aud_forging_4.play()

func activateBuff(): #Block, MaxHP, healBleed
	buffLevel += 1
	if !buffActive:
		buffActive = true
		lbl_buff.visible = true
		lbl_buff_level.visible = true
		match buffType:
			0: lbl_buff.text = str("+Block")
			1: lbl_buff.text = str("+MaxHP")
			2: lbl_buff.text = str("-Bleed")
	lbl_buff_level.text = str("Lvl", buffLevel)

func deactivateBuff():
	buffLevel = 0
	buffActive = false
	lbl_buff.visible = buffActive
	lbl_buff_level.visible = buffActive

func _on_button_button_up():
	upgradePressed = false

func _on_btn_regenerate_button_down():
	if Global.regenerateOres > 0:
		Global.regenerateOres -= 1
		Global.regenerateOreSpent.emit()
		deactivateBuff()
		generate((randi()%10)+1)
		setSprite()
		updateHUD()

func _on_btn_buff_lvl_up_button_down():
	buffPressed = true
	buffLevelUp()

func buffLevelUp():
	while buffPressed:
		if Global.buffLvlOres > 0:
			Global.buffLvlOres -= 1
			Global.buffLvlOreSpent.emit()
			activateBuff()
			updateHUD()
		else:
			buffPressed = false
		await get_tree().create_timer(0.09).timeout

func _on_btn_buff_lvl_up_button_up():
	buffPressed = false
