extends Area2D

export(Resource) var item

onready var sprite = $Sprite
onready var player_bag = preload("res://src/characters/player/PlayerBag.tres")

func _ready():
	sprite.texture = item.texture

func _on_Item_body_entered(_body):
	player_bag.add_item(item)
	queue_free()
