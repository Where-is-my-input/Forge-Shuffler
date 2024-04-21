extends Node2D

@onready var text_edit = $TextEdit
@onready var cemetery_cards = $CemeteryCards

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO optimize
	text_edit.text = str(getCemeterySize())

func getCemeterySize():
	return cemetery_cards.get_child_count()

func getCards():
	return cemetery_cards.get_children()

func addCard(card):
	cemetery_cards.add_child(card)
