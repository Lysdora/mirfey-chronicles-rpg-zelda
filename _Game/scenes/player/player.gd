extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var vitesse: float = 40.0

var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN  # direction par défaut

func _physics_process(_delta: float) -> void:
	move_player()
	animation_player()
	move_and_slide()

func move_player():
	direction = Input.get_vector("left", "right", "up", "down")

	# 🧠 On garde en mémoire la dernière direction utilisée
	if direction != Vector2.ZERO:
		last_direction = direction

	velocity = direction * vitesse

func animation_player():
	if direction != Vector2.ZERO:
		if direction.x > 0:
			animated_sprite.play("walk_right")
		elif direction.x < 0:
			animated_sprite.play("walk_left")
		elif direction.y > 0:
			animated_sprite.play("walk_down")
		elif direction.y < 0:
			animated_sprite.play("walk_up")
	else:
		if last_direction.x > 0:
			animated_sprite.play("idle_right")
		elif last_direction.x < 0:
			animated_sprite.play("idle_left")
		elif last_direction.y > 0:
			animated_sprite.play("idle_down")
		elif last_direction.y < 0:
			animated_sprite.play("idle_up")
