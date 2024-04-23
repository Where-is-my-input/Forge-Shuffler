extends Node

@onready var sfx_get_block = $sfxGetBlock
@onready var sfx_sword = $sfxSword
@onready var sfx_heal = $sfxHeal
@onready var sfx_break_block = $sfxBreakBlock
@onready var sfx_get_hit = $sfxGetHit
@onready var sfx_miss = $sfxMiss

func playGetBlock():
	sfx_get_block.play()

func playHeal():
	sfx_heal.play()

func playBreakBlock():
	sfx_break_block.play()

func playGetHit():
	sfx_get_hit.play()

func playMiss():
	sfx_miss.play()
