
# 🦦 Guide : Création d'un Ennemi Patrouilleur (Taupe Rouge Grognon) dans Godot 4.4

Ce guide va te montrer comment créer un ennemi patrouilleur basique (une Taupe Rouge Grognon) qui se déplace entre deux points définis par des marqueurs (`Marker2D`) dans Godot 4.4.

---

## 📁 1. Organisation des fichiers

Pour bien organiser ton projet, crée un dossier pour tes ennemis.

```
res://
│
├── Player.tscn
├── Player.gd
├── Enemies/
│   ├── Mole.tscn
│   ├── Mole.gd
```

---

## 🦦 2. Création de la scène de la Taupe Rouge Grognon (`Mole.tscn`)

1. **Ouvre Godot et crée une nouvelle scène.**
2. **Ajoute un `CharacterBody2D`** comme nœud principal et nomme-le `Mole`.
3. **Ajoute un `AnimatedSprite2D`** en tant qu'enfant du `CharacterBody2D`.
4. **Ajoute deux `Marker2D`** comme enfants de `Mole`.
   - Renomme-les `Marker_A` et `Marker_B`.
   - Place-les où tu veux dans ta scène pour définir le parcours de patrouille.

---

## 📜 3. Script complet de la Taupe Rouge Grognon (`Mole.gd`)

```gdscript
extends CharacterBody2D

# 🦦 On accède à l'AnimatedSprite2D pour gérer ses animations
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# 🚀 Vitesse de déplacement de la taupe
@export var vitesse: float = 40.0  

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

func _ready():
    # 📍 On récupère les positions GLOBALES des marqueurs
    point_a = marker_a.global_position
    point_b = marker_b.global_position

    # 🦦 La taupe commence par regarder vers le bas
    animated_sprite.play("idle_down")

func _physics_process(delta: float) -> void:
    move_enemy()
    animation_player()
    move_and_slide()

func move_enemy():
    # 🎯 Déterminer la position cible (point A ou point B)
    var target_position = point_b if going_to_b else point_a

    # ➡️ Calculer la direction vers laquelle on doit se déplacer
    direction = (target_position - global_position).normalized()

    # 💨 Appliquer la vitesse pour calculer la vitesse finale
    velocity = direction * vitesse

    # ✅ Si la taupe est proche du point cible, elle change de direction
    if global_position.distance_to(target_position) < 5:
        going_to_b = not going_to_b  # 🪃 Inverser le parcours

func animation_player():
    # 🎥 On joue les animations selon la direction de déplacement
    if direction != Vector2.ZERO:
        last_direction = direction  # 🧠 On garde en mémoire la dernière direction utilisée

        if direction.x > 0:
            animated_sprite.play("walk_right")
        elif direction.x < 0:
            animated_sprite.play("walk_left")
        elif direction.y > 0:
            animated_sprite.play("walk_down")
        elif direction.y < 0:
            animated_sprite.play("walk_up")
    else:
        # 😴 Si la taupe ne bouge pas, on affiche l'animation idle correspondante
        if last_direction.x > 0:
            animated_sprite.play("idle_right")
        elif last_direction.x < 0:
            animated_sprite.play("idle_left")
        elif last_direction.y > 0:
            animated_sprite.play("idle_down")
        elif last_direction.y < 0:
            animated_sprite.play("idle_up")
```

---

## ✅ 4. Explications

- 🔥 On utilise `global_position` au lieu de `position` pour que la taupe sache où se trouvent les marqueurs même s'ils sont placés ailleurs dans la scène.
- 📍 Les marqueurs `Marker_A` et `Marker_B` définissent le parcours de patrouille de la taupe.
- 🦦 La taupe se déplace d'un marqueur à l'autre et change de direction lorsqu'elle atteint l'un des deux.

---

🎉 **Bravo ! Tu as créé ta Taupe Rouge Grognon qui patrouille entre deux points.** Tu veux maintenant ajouter une logique pour qu'elle attaque Elara si elle s'approche trop près ? 😈🔥
