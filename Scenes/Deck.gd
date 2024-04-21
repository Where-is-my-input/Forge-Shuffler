extends Node2D

@onready var deck_cards = $DeckCards
const CardBase = preload("res://Scenes/card.tscn")
@onready var text_edit = $TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO optimize
	text_edit.text = str(getDeckSize())

func generateDeck(cardAmount):
	for n in cardAmount:
		var newCard = CardBase.instantiate()
		newCard.visible = false
		newCard.generate((randi() % 10) + 1)
		deck_cards.add_child(newCard)

func getCard(index):
	return deck_cards.get_child(index)

func getDeckSize():
	return deck_cards.get_child_count()

func addCard(card):
	deck_cards.add_child(card)

func getCards():
	return deck_cards.get_children()

func hideCards():
	for c in getCards():
		c.hideCard()
