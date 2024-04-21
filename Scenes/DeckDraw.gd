extends TextureButton
@onready var player = $"../.."
@onready var deck = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _gui_input(event):
	if Input.is_action_just_released("action"):
		if deck.getDeckSize() > 0 && !player.viewingCards:
			player.viewCards(deck.getCards())
			player.deckCemeteryView = 2
