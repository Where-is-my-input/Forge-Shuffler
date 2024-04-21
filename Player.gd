extends Node2D

const CardBase = preload("res://Scenes/card.tscn")
var DeckSize = 15
var PlayerHand = []
@onready var cards = $Cards
@onready var deck = $Deck
@onready var cemetery = $Cemetery
@onready var hp = $HP
@onready var view_cards = $ViewCards
@onready var hp_label = $HP/hpLabel
@onready var lbl_ore = $oreSprite/lblOre
@onready var block = $Block
@onready var lbl_block = $Block/lblBlock
@onready var lbl_damage_taken = $lblDamageTaken
@onready var timer_damage_taken = $lblDamageTaken/timerDamageTaken
@onready var spr_bleeding = $sprBleeding
@onready var timer_draw_hand = $timerDrawHand
@onready var lbl_heal = $lblHeal

@onready var CentreCardOval = Vector2(get_viewport().size.x, get_viewport().size.y) * Vector2(0.5, 1)
@onready var Hor_rad = get_viewport().size.x * 0.65
@onready var Ver_rad = get_viewport().size.y * 0.4
var angle = deg_to_rad(90) - 0.3
var OvalAngleVector = Vector2()

var viewingCards = false
var deckCemeteryView = 0

var maxHP = 10
var currentHp = maxHP
var maxBlock = 3
var currentBlock = 0

var bleeding = false
var bleedingTurns = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	lbl_heal.visible = false
	#Global.cardAction.connect(endTurn)
	deck.generateDeck(DeckSize)
	Global.setDeck(deck)
	draw(3)
	view_cards.visible = false
	lbl_damage_taken.visible = false
	updateHUD()

func drawCard():
	OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
	var cardSelected = randi() % deck.getDeckSize()
	var newCard = deck.getCard(cardSelected)
	newCard.addToHand(CentreCardOval + OvalAngleVector / 2)
	newCard.removeParent()
	cards.add_child(newCard)
	angle += 0.3

func createCard():
	var newCard = CardBase.instantiate()
	cards.add_child(newCard)

func reshuffle():
	for child in cemetery.getCards():
		child.removeParent()
		deck.addCard(child)

func draw(value):
	if deck.getDeckSize() <= 0:
		reshuffle()
	for n in value:
		drawCard()
	angle -= 0.9

func updateHUD():
	hp.max_value = maxHP
	hp.value = currentHp
	hp_label.text = str(currentHp, "/", maxHP)
	lbl_ore.text = str("x", Global.ores)
	lbl_block.text = str(currentBlock)
	spr_bleeding.visible = bleeding
	block.visible = currentBlock > 0

func endTurn():
	bleed()
	cards.endTurn()

func bleed():
	if bleeding:
		currentHp -= floor(maxHP * 0.1)
		bleedingTurns -= 1
		updateHUD()
		if bleedingTurns <= 0:
			bleeding = false
	if currentHp <= 0:
		gameOver()

func getHit(damage, blockBreak = false, flBleeding = false):
	if currentBlock >= damage:
		damage = 0
	if blockBreak:
		currentBlock = 0
		damage = 0
	if flBleeding:
		bleedingTurns = floor(damage/3)
		bleeding = true
	damage = floor(damage)
	currentHp -= damage
	if damage > 0:
		lbl_damage_taken.visible = true
		lbl_damage_taken.text = str("-", damage)
		timer_damage_taken.start(3)
	updateHUD()
	if currentHp <= 0:
		gameOver()
	return damage > 0

func restart():
	startTurn()
	currentBlock = 0
	bleeding = false
	currentHp = maxHP
	updateHUD()

func startTurn():
	timer_draw_hand.start(2)

func endFloor():
	cards.killCards()
	timer_damage_taken.timeout.emit()
	for c in cemetery.getCards():
		c.removeParent()
		deck.addCard(c)

func heal(value):
	bleeding = false
	currentHp += floor(value)
	if currentHp > maxHP:
		currentHp = maxHP
	if floor(value) > 0:
		lbl_heal.text = str("+", floor(value))
		lbl_heal.visible = true
	updateHUD()

func viewCards(cards):
	if viewingCards:
		viewingCards = false
		view_cards.visible = false
		for c in cards:
			c.hideCard()
		return
	viewingCards = true
	view_cards.visible = true
	#view_cards.visible = true
	var initialX = 100
	var position = Vector2(initialX, 150)
	var offset = Vector2(120, 180)
	var viewportSize = get_viewport().size
	for c in cards:
		c.view(position)
		position.x += offset.x
		if position.x >= viewportSize.x:
			position.x = initialX
			position.y += offset.y

func _on_button_pressed():
	if deckCemeteryView == 1:
		viewCards(cemetery.getCards())
	else:
		viewCards(deck.getCards())

func gameOver():
	cards.killCards()
	reshuffle()
	Global.gameOver.emit()

func getOre(value):
	Global.ores += randi_range(value/2, value * 2)
	updateHUD()

func getDeckCards():
	return deck.getCards()

func hideCards():
	deck.hideCards()

func getBlock(value, flBuffBlock = false):
	if floor(value) > currentBlock:
		currentBlock = floor(value)
	if flBuffBlock:
		maxBlock += 1
	if currentBlock > maxBlock:
		currentBlock = maxBlock
	updateHUD()

func _on_timer_timeout():
	lbl_heal.visible = false
	lbl_damage_taken.visible = false

func getMaxHP(value):
	maxHP += value
	updateHUD()

func lowerBleeding(value):
	bleedingTurns -= value
	if bleedingTurns <= 0:
		bleeding = false

func _on_timer_draw_hand_timeout():
	draw(3)
