extends Node2D

onready var sprite = $Player/Sprite
onready var label = $CreationScreen/Skin/Label

const sprites = {
	"hero": preload("res://Player/Heroi.png"),
	"heroine": preload("res://Player/Heroina.png"),
	"hero_alt": preload("res://Player/Heroi alt.png"),
	"heroine_alt": preload("res://Player/Heroina alt.png")
}
const femaleButton = {
	"normal": preload("res://Assets/Ui/female_button.png"),
	"pressed": preload("res://Assets/Ui/female_button_pressed.png")
}
const maleButton = {
	"normal": preload("res://Assets/Ui/male_button.png"),
	"pressed": preload("res://Assets/Ui/male_button_pressed.png")
}

var skin: int = 0
var gender: int = 0

func _ready():
	changeTexture()

func _on_Female_pressed():
	gender = 0
	changeTexture()

func _on_TextureButton_pressed():
	gender = 1
	changeTexture()

func _on_Next_pressed():
	skin = (skin + 1) % (sprites.size() / 2)
	changeTexture()

func _on_Previous_pressed():
	skin = (sprites.size() / 2) - 1 if skin == 0 else (skin - 1) % (sprites.size() / 2)
	changeTexture() 

func changeTexture():
	if (gender == 0):
		$CreationScreen/Female.texture_normal = femaleButton.pressed
		$CreationScreen/Male.texture_normal = maleButton.normal
	else:
		$CreationScreen/Male.texture_normal = maleButton.pressed
		$CreationScreen/Female.texture_normal = femaleButton.normal

	var character = "heroine" if gender == 0 else "hero"
	if (skin == 1):
		character += "_alt"
	sprite.texture = sprites[character]
	label.text = String(skin + 1)
