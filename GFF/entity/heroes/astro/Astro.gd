extends Character

onready var blaster: Node2D = get_node("Blaster")
onready var blaster_animation: AnimationPlayer = blaster.get_node("AnimationBlaster")
onready var attack_timer = $AttackTimer

var BULLET_SCENE = preload("res://entity/heroes/astro/Bullet.tscn")

var direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

	blaster.rotation = mouse_direction.angle()
	if blaster.scale.y == 1 and mouse_direction.x < 0:
		blaster.scale.y = -1
	elif blaster.scale.y == -1 and mouse_direction.x > 0:
		blaster.scale.y = 1


func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction += Vector2.UP
	
	if Input.is_action_just_pressed("ui_attack"):
		if attack_timer.is_stopped():
			shoot()
			attack_timer.start()


func shoot() -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	var bullet: Area2D = BULLET_SCENE.instance()
	get_tree().current_scene.add_child(bullet)
	bullet.launch(global_position, mouse_direction, 400)
