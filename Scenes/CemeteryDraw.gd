extends TextureButton
@onready var player = $"../.."
@onready var cemetery = $".."

func _gui_input(event):
	if Input.is_action_just_released("action"):
		if cemetery.getCemeterySize() > 0 && !player.viewingCards:
			player.viewCards(cemetery.getCards())
			player.deckCemeteryView = 1
