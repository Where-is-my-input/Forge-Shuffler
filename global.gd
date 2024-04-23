extends Node

signal cardAction(Card: Node2D)
signal enemyAction(Enemy: Node2D)
signal enemyDead()
signal gameOver()
signal oreSpent()
const MAIN_SCENE : PackedScene = preload("res://Scenes/main_menu.tscn")

var ores = 1000
var deck

func setDeck(cards):
	deck = cards
