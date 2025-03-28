# 🔥 Système de dégâts simple pour ton RPG style Zelda

👋 Dans ce guide, je vais t'expliquer comment j'ai créé un **système de dégâts basique** pour mon jeu RPG façon Zelda avec Godot 4.4. C'est parti ! 🚀

## 🧩 Vue d'ensemble du système

Mon système de dégâts se compose de 3 éléments principaux :
1. Un ennemi (taupe) avec une zone de dégâts (HurtyBox)
2. Un gestionnaire de vie global (GameState)
3. Une interface utilisateur (UI) pour afficher les cœurs

## 🛠️ Configuration de l'ennemi avec zone de dégâts

Voici le code complet de mon ennemi (taupe) qui se déplace entre deux points et peut infliger des dégâts au joueur :

```gdscript
extends CharacterBody2D
# 🦦 On accède à l'AnimatedSprite2D pour gérer ses animations
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# 🚀 Vitesse de déplacement de la taupe
@export var vitesse: float = 15.0  
# 📍 Marqueurs de patrouille (on les récupère par nom)
@onready var marker_a = $Marker_A
@onready var marker_b = $Marker_B
# 🌍 Points de patrouille récupérés depuis les marqueurs
var point_a: Vector2
var point_b: Vector2
# 📌 Direction actuelle de l'ennemi (A -> B ou B -> A)
var going_to_b: bool = true
# 🔀 La direction actuelle (pour animer correctement la taupe)
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN  # Par défaut, elle regarde vers le bas
@onready var detection_area = $HurtyBox
var can_damage: bool = true
var damage_cooldown: float = 0.0

func _ready():
	if marker_a and marker_b:
		point_a = marker_a.global_position
		point_b = marker_b.global_position
	else:
		print("Erreur : Marker_A ou Marker_B n'est pas trouvé !")
	
	if animated_sprite:
		animated_sprite.play("idle_down")
	else:
		print("Erreur : AnimatedSprite2D non trouvé !")

func _physics_process(delta: float) -> void:
	if not can_damage:
		damage_cooldown -= delta
		if damage_cooldown <= 0:
			can_damage = true
			print("Cooldown fini, peut infliger des dégâts")
	move_enemy()
	animation_player()
	move_and_slide()

func move_enemy():
	var target_position = point_b if going_to_b else point_a
	direction = (target_position - position).normalized()
	velocity = direction * vitesse
	if position.distance_to(target_position) < 5:
		going_to_b = not going_to_b

func animation_player():
	if not animated_sprite:
		return
	if direction != Vector2.ZERO:
		last_direction = direction
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

func _on_hurty_box_body_entered(body):
	if body.is_in_group("player") and can_damage:
		print("Joueur touché !")
		GameState.decrease_health()
		can_damage = false
		damage_cooldown = 1.0  # 1 seconde de cooldown
```

## 🧠 Le GameState (Autoload) pour gérer la vie

Pour gérer la vie du joueur de manière globale, j'utilise un script en autoload :

```gdscript
# 📁 Scripts/GameState.gd (Autoload)
extends Node

@export var max_health: int = 3  # Nombre maximum de cœurs
var current_health: int = max_health  # Nombre actuel de cœurs

signal health_changed  # Signal pour notifier les changements

func decrease_health():
	current_health = max(current_health - 1, 0)
	health_changed.emit()

func increase_health():
	current_health = min(current_health + 1, max_health)
	health_changed.emit()
```

## 🎮 L'interface utilisateur (UI) pour afficher les cœurs

Voici le script de mon interface qui affiche les cœurs :

```gdscript
# 📁 UI/UI.gd
extends CanvasLayer

@onready var heart_container = $HeartContainer/Hearts
@export var heart_full: Texture2D
@export var heart_empty: Texture2D

func _ready():
	GameState.health_changed.connect(update_hearts)
	update_hearts()

func update_hearts():
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i) as TextureRect
		if i < GameState.current_health:
			heart.texture = heart_full  # Cœur plein
		else:
			heart.texture = heart_empty  # Cœur vide
```

## 📝 Comment ça fonctionne

1. **Détection des dégâts** : J'ai ajouté une `Area2D` nommée `HurtyBox` à mon ennemi.

2. **Système de cooldown** : Quand l'ennemi inflige des dégâts, il ne peut pas en infliger à nouveau pendant 1 seconde. Cela évite de perdre toute sa vie en restant en contact avec l'ennemi.

3. **Flux du système** :
   - Le joueur entre en contact avec la `HurtyBox` de l'ennemi
   - La fonction `_on_hurty_box_body_entered` est appelée
   - La fonction vérifie si le corps est bien le joueur et si l'ennemi peut infliger des dégâts
   - La fonction `decrease_health()` est appelée sur le GameState
   - Le GameState émet le signal `health_changed`
   - L'UI met à jour l'affichage des cœurs

## 🎮 Configuration dans l'éditeur Godot

1. **Configuration de l'ennemi** :
   - Ajoute un nœud `Area2D` nommé "HurtyBox" comme enfant de ton ennemi
   - Ajoute un `CollisionShape2D` comme enfant de "HurtyBox"
   - Définit la forme et la taille de la collision
   - Connecte le signal "body_entered" du nœud "HurtyBox" à ton script d'ennemi

2. **Configuration de GameState** :
   - Crée un script "GameState.gd"
   - Va dans Project > Project Settings > Autoload
   - Ajoute ton script et nomme-le "GameState"

3. **Configuration de l'UI** :
   - Crée une scène UI avec un CanvasLayer comme nœud racine
   - Ajoute un conteneur pour les cœurs
   - Ajoute des TextureRect pour chaque cœur
   - Assigne les textures heart_full et heart_empty

## 💡 Conseils supplémentaires

- **Groupe "player"** : Assure-toi que ton joueur est dans le groupe "player" pour que la détection fonctionne
- **Debug** : Utilise les messages "print" pour voir quand les dégâts sont infligés et quand le cooldown se termine
- **Effets visuels** : Tu pourrais ajouter un effet visuel quand le joueur prend des dégâts (clignotement, animation, etc.)

Et voilà ! C'est un système simple mais efficace pour gérer les dégâts dans ton jeu RPG. Tu peux bien sûr l'étendre avec plus de fonctionnalités selon tes besoins. 🎮✨

Bon développement ! 😊
