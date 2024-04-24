extends Node2D

@onready var lbl_ore = $oreSprite/lblOre
@onready var main = $".."

func _ready():
	Global.oreSpent.connect(updateHUD)
	visible = false

func viewCards(cards):
	updateHUD()
	var initialX = 100
	var position = Vector2(initialX, 150)
	var offset = Vector2(120, 220)
	var viewportSize = get_viewport().content_scale_size
	for c in cards:
		c.view(position, true)
		position.x += offset.x
		if position.x >= viewportSize.x:
			position.x = initialX
			position.y += offset.y

func updateHUD():
	lbl_ore.text = str("x", Global.ores)

func _on_continue_pressed():
	main.continueGameScene()
