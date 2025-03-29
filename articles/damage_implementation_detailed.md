
# 💥 Guide Détaillé : Implémenter un Système de Dégâts (HurtyBox & GameState)

Ici, on va apprendre à faire en sorte que notre taupe puisse **infliger des dégâts à Elara** ! 🦦💥 On va aussi connecter ce système à un **HUD qui affiche des cœurs**, pour bien voir la vie restante. C'est parti ! 🚀

---

## 🎯 Objectif
- Créer un système de dégâts où l'ennemi peut blesser Elara. 🔥
- Afficher la santé d'Elara avec des cœurs sur l'écran. ❤️

---

## 🔍 Étape 1 : Créer le GameState (Autoload)

Nous allons gérer la vie d’Elara avec un **Autoload** appelé `GameState`. Ce script sera disponible partout dans ton jeu.

### 📁 Scripts/GameState.gd (Autoload)

```gdscript
extends Node

@export var max_health: int = 3  # Nombre maximum de cœurs qu'Elara peut avoir
var current_health: int = max_health  # Nombre actuel de cœurs

signal health_changed  # Signal qui sera émis lorsque la vie change

func decrease_health():
    current_health = max(current_health - 1, 0)
    health_changed.emit()
    print("Ouch ! Elara a perdu un cœur ! 💔")

func increase_health():
    current_health = min(current_health + 1, max_health)
    health_changed.emit()
    print("Yeah ! Elara a gagné un cœur ! ❤️")
```

### 📌 Explications :
- **`max_health`** : Le nombre maximum de cœurs qu'Elara peut avoir (par défaut 3).
- **`current_health`** : Le nombre actuel de cœurs qu’Elara a. On commence avec tous les cœurs disponibles.
- **`health_changed`** : Un signal qui est émis chaque fois que la vie change. Cela permet d’actualiser le HUD ! 🎯

💡 **Autoload** signifie que ce script est toujours présent en mémoire. Pour l'ajouter :  
- Va dans **Project > Project Settings > Autoload**.
- Clique sur **Path**, choisis ton script `GameState.gd` et donne-lui le nom `GameState`.
- Clique sur **Add**. 🎉

---

## 🔍 Étape 2 : Ajouter la HurtyBox à la Taupe

Maintenant, on va permettre à notre taupe d’infliger des dégâts lorsqu’elle touche Elara. 😈

### 📁 Scripts/Mole.gd (Ajout d’une HurtyBox)

```gdscript
extends CharacterBody2D

@onready var detection_area = $HurtyBox  # L’Area2D qui détecte Elara
var can_damage: bool = true
var damage_cooldown: float = 0.0  # Temps avant de pouvoir infliger des dégâts à nouveau

func _physics_process(delta: float) -> void:
    if not can_damage:
        damage_cooldown -= delta
        if damage_cooldown <= 0:
            can_damage = true
            print("Cooldown terminé, la taupe peut attaquer à nouveau !")

func _on_hurty_box_body_entered(body):
    if body.is_in_group("player") and can_damage:
        print("Elara a été touchée par la taupe ! 😵")
        GameState.decrease_health()
        can_damage = false
        damage_cooldown = 1.0  # Temps de recharge avant la prochaine attaque (1 seconde)
```

### 📌 Explications :
- **HurtyBox** : Un `Area2D` que tu places comme enfant de ta taupe. Crée une `CollisionShape2D` dedans pour définir la zone d’attaque.
- **`damage_cooldown`** : On met un délai avant de pouvoir infliger des dégâts à nouveau (ici, 1 seconde).

🎯 **Important :** N’oublie pas d’ajouter le groupe `player` à ton personnage Elara ! (Clic droit sur Elara > `Groups` > Ajoute `player`)

---

## 🔍 Étape 3 : Affichage des Cœurs (HUD)

On va maintenant créer un HUD pour afficher la vie d’Elara avec des petits cœurs. ❤️

### 📁 UI/UI.gd

```gdscript
extends CanvasLayer

@onready var heart_container = $HeartContainer/Hearts  # Un Node qui contient les cœurs
@export var heart_full: Texture2D
@export var heart_empty: Texture2D

func _ready():
    GameState.health_changed.connect(update_hearts)
    update_hearts()

func update_hearts():
    for i in range(heart_container.get_child_count()):
        var heart = heart_container.get_child(i) as TextureRect
        if i < GameState.current_health:
            heart.texture = heart_full  # Cœur plein ❤️
        else:
            heart.texture = heart_empty  # Cœur vide 💔
```

### 📌 Explications :
- **`heart_container`** : Un `HBoxContainer` ou un `Node2D` qui contient des `TextureRect` représentant les cœurs.
- **`heart_full` / `heart_empty`** : Deux images représentant un cœur plein et un cœur vide.

---

## ✅ Teste ton système de dégâts !

1. 🦦 Fais en sorte que ta taupe puisse toucher Elara.  
2. ❤️ Observe les cœurs diminuer à chaque attaque.  
3. 📢 Ajoute des sons, des effets visuels, tout ce que tu veux !

✨ **Bravo !** Tu as maintenant un système de dégâts fonctionnel avec une interface super cool ! 😎🎉

Prochaine étape : Faire en sorte qu’Elara puisse se défendre. 🔥💪
