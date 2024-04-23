extends Node
@onready var sfx_sword = $sfxSword

func playGetHit():
	sfx_sword.play()
