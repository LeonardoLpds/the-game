extends KinematicBody2D

# Nodes
onready var hitbox = find_node("Hitbox")

# Stats
export(int) var lvl := 1 setget set_lvl

export(int) var vit := 1 setget set_vit
export(int) var strg := 1 setget set_strg
export(int) var agi := 1
export(int) var dex := 1

# Attributes
var max_hp
var hp setget set_hp
var attack setget set_atk

# Signals
signal no_hp

func _ready():
	calc_attributes()
	self.hp = max_hp

# Sets and Gets
func set_lvl(value):
	lvl = value
	calc_attributes()

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("no_hp")
		
func set_strg(value):
	strg = value
	calc_atk()

func set_atk(value):
	attack = value
	if hitbox:
		hitbox.set("damage", attack)

func set_vit(value):
	vit = value
	calc_max_hp()

func hurt(value):
	self.hp -= value

# Calc Attributes
func calc_attributes():
	calc_max_hp()
	calc_atk()
	
func calc_max_hp():
	var base_hp = 35 + (lvl * 5)
	for i in range(2, lvl +1):
		base_hp += round(0.5 * i)
	max_hp = floor(base_hp * (1 + vit * 0.01))

func calc_atk():
	self.attack = floor((float(lvl) / 4) + strg)
