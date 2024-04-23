extends Node

signal cardAction(Card: Node2D)
signal enemyAction(Enemy: Node2D)
signal enemyDead()
signal gameOver()
signal oreSpent()

var ores = 1000
var deck

func setDeck(cards):
	deck = cards
