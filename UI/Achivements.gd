extends Control

onready var batLabel = $Bats/BatLabel
onready var slimeLabel = $Slimes/SlimeLabel
onready var keyLabel = $Keys/KeyLabel

signal update_achivement

func update_achivement():
	batLabel.text = " x " + str(PlayerStats.bats)
	slimeLabel.text = " x " + str(PlayerStats.slimes)
	keyLabel.text = " x " + str(PlayerStats.keys)
