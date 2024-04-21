extends Node

const EnemyBase = preload("res://Scenes/enemy.tscn")
@onready var enemy = $Enemy
@onready var main = $"../.."


func getHit(value, damageType = 0):
	get_child(0).getHit(value, damageType)

func newEnemy():
	var generateNewEnemy = EnemyBase.instantiate()
	self.add_child(generateNewEnemy)
	generateNewEnemy.generate(randi_range(main.floor / 2, main.floor), main.floor)

func playTurn():
	get_child(0).playTurn()

func restart():
	get_child(0).queue_free()
	newEnemy()

func getType():
	return get_child(0).getType()

func getTypeVariation():
	return get_child(0).getTypeVariation()

func heal(value):
	get_child(0).heal(value)

func die():
	get_child(0).queue_free()
