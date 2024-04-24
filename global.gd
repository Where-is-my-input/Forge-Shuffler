extends Node

signal cardAction(Card: Node2D)
signal enemyAction(Enemy: Node2D)
signal enemyDead()
signal gameOver()
signal oreSpent()
signal regenerateOreSpent()
signal buffLvlOreSpent()
const MAIN_SCENE : PackedScene = preload("res://Scenes/main_menu.tscn")

var ores = 0
var regenerateOres = 3
var buffLvlOres = 5
var deck

func setDeck(cards):
	deck = cards
