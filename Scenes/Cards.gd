extends Node
@onready var cemetery = $"../Cemetery"
@onready var player = $".."

func endTurn():
	killCards()

func killCards():
	for n in get_children():
		n.removeFromPlay()
		n.removeParent()
		cemetery.addCard(n)

func cardAction(card):
	if !player.viewingCards:
		Global.cardAction.emit(card)
