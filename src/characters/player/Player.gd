extends Character

# Ready
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var weaponSprite = $WeaponSprite
onready var hitbox = $HitboxPivot/Hitbox
onready var spawnPivot = $HitboxPivot/SpawnPivot
onready var skillCaster = $SkillCaster

# State machine
enum { MOVE, ATTACK, HURT, DIE, SKILL }
var state = MOVE

# Move variables
const WALK_SPEED = 100
const ACCELERATION = 15
var velocity = Vector2.ZERO

# Equips
var weapon: Item setget set_weapon
export(Resource) var equips
var arrow = preload("res://src/items/scenes/Arrow.tscn")
var energy = preload("res://src/items/scenes/Energy Ball.tscn")

# Skills
export(Resource) var skills
export(int) var skill_points setget _set_skill_points
signal skill_points_changed

func _ready() -> void:
	equips.connect("items_changed", self, "_on_equip_changed")

func _physics_process(_delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		HURT:
			hurt_state()
		DIE:
			die_state()
		SKILL:
			skill_state()

# States
func move_state():
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input = Vector2(x, y).normalized()

	velocity = move_and_slide(velocity.move_toward(input * WALK_SPEED, ACCELERATION))

	if input != Vector2.ZERO:
		animationState.travel("Run")
		for animation in ["Idle", "Run", "Hurt"]:
			animationTree.set("parameters/"+animation+"/blend_position", input)
		animationTree.set("parameters/Die/blend_position", input.x)
		
		if (weapon):
			animationTree.set("parameters/Attack/"+str(weapon.type)+"/blend_position", input)
	else:
		animationState.travel("Idle")
	
	# Buttons Handler
	if Input.is_action_just_pressed("attack") and weapon:
		state = ATTACK
		
	for skill in skills.skills:
		if skill.shortcut and Input.is_action_just_pressed(skill.shortcut) and weapon:
			state = SKILL
			skillCaster.cast(skill)

func attack_state():
	velocity = Vector2.ZERO
	animationTree.tree_root.get_node("Attack").set_start_node(str(weapon.type))
	animationState.travel("Attack")

func reset_state():
	state = MOVE

func hurt_state():
	velocity = Vector2.ZERO
	if animationState.get_current_node() != "Attack":
		animationState.travel("Hurt")

func die_state():
	velocity = Vector2.ZERO
	set_physics_process(false)
	animationState.travel("Die")
	
func skill_state():
	print("SKILL STATE")
	reset_state()

# Helpers
func set_weapon(new_weapon):
	weapon = new_weapon
	if (weapon is Item):
		weaponSprite.frame = 0
		if (weapon.animation != null):
			weaponSprite.set_texture(weapon.animation)
			_animation_weapon()
		else:
			weaponSprite.set_texture(weapon.texture)
			_no_animation_weapon()

	_set_hitbox_damage()

func _no_animation_weapon():
	weaponSprite.hframes = 1
	weaponSprite.vframes = 1

func _animation_weapon():
	weaponSprite.hframes = 4
	weaponSprite.vframes = 3
	
func spawn_projectile(projectile):
	projectile.global_position = spawnPivot.global_position
	projectile.rotation = animationTree.get("parameters/Attack/"+str(weapon.type)+"/blend_position").angle()
	projectile.damage = hitbox.damage
	get_parent().add_child(projectile)
	
func spawn_arrow():
	spawn_projectile(arrow.instance())
	
func spawn_energy():
	spawn_projectile(energy.instance())
	
func spend_skill_points(amount: int = 1) -> void:
	self.skill_points -= amount

func _set_skill_points(amount: int) -> void:
	skill_points = amount
	emit_signal("skill_points_changed", skill_points)
	

# Signals
func _on_equip_changed(indexes: Array) -> void:
	if (indexes.has(3)):
		self.weapon = equips.items[3]

func _on_Player_no_hp():
	state = DIE

func _on_Player_attack_change():
	call_deferred("_set_hitbox_damage");

func _set_hitbox_damage():
	hitbox.damage = self.attack + (weapon.attack if weapon else 0)

func _on_Player_hurt():
	state = HURT
