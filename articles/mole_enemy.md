
# 🐾 Guide Détaillé : Déplacement de la Taupe Rouge (Patrouille & Animations)

Bienvenue dans ce guide ! Ici, tu vas apprendre à **créer une taupe ennemie qui patrouille entre deux points**. Elle saura changer d'animation selon la direction dans laquelle elle se déplace. Prêt(e) ? C'est parti ! 🚀

---

## 🎯 Objectif
- Créer un ennemi qui patrouille automatiquement.  
- Gérer ses animations selon la direction de déplacement.

---

## 🔍 Étape 1 : Préparer la scène de la taupe

### 🔨 Créer une nouvelle scène pour la taupe

1. **Dans ton projet Godot, fais un clic droit dans ton dossier `Scenes` > `New Scene`.**  
2. **Choisis un `CharacterBody2D` comme nœud principal.**  
   - Pourquoi `CharacterBody2D` ? 👉 Parce que c’est un nœud spécial qui permet à un personnage de **se déplacer facilement** avec la fonction `move_and_slide()`.  
3. **Renomme-le en `Mole`**. Cela permet de bien identifier notre taupe ! 😄  

💡 **Astuce :** Appuie sur `Ctrl + S` pour sauvegarder ta scène. Nomme-la `Mole.tscn`.

---

## 🔍 Étape 2 : Ajouter les éléments nécessaires

Maintenant qu’on a notre taupe, on va lui ajouter des éléments pour qu’elle puisse **se déplacer et jouer des animations**. 🎬

### ✨ Ajouter un `AnimatedSprite2D`

1. **Clique sur ton nœud `Mole`.**  
2. **Fais un clic droit > `Add Child Node` > Recherche `AnimatedSprite2D` > Clique sur `Create`.**  
3. **Renomme-le en `AnimatedSprite2D`.**  

📝 **Explication :**  
- `AnimatedSprite2D` permet d’afficher des sprites animés (par exemple, notre taupe qui marche).  
- On peut lui donner différentes animations (`walk_left`, `walk_right`, etc.) que l’on pourra **changer par code**.  

### 📌 Configurer `AnimatedSprite2D`

1. **Sélectionne ton nœud `AnimatedSprite2D` et va dans l’onglet `Inspector`.**  
2. **Dans la section `SpriteFrames`, clique sur `[empty]` > `New SpriteFrames`.**  
3. **Clique sur l’icône `SpriteFrames` pour ouvrir l’éditeur d’animations.**  
4. **Clique sur le bouton `+` pour ajouter une animation (par exemple `walk_left`).**  
5. **Ajoute les frames de l’animation (`drag & drop` ou `Add Frames` si tu les as importées).**  
6. **Répète pour chaque direction (`walk_left`, `walk_right`, `walk_up`, `walk_down`).**  

🎯 **Astuce :** Mets une vitesse raisonnable (`FPS`) pour chaque animation. Par exemple `8 FPS`.

---

## 🔍 Étape 3 : Ajouter des Points de Patrouille (Markers)

### ❌ Erreur courante : Ne pas placer les Markers dans la scène de la taupe !

Les `Markers` doivent être ajoutés **dans la scène principale**, et non dans la scène `Mole.tscn` de la taupe. Sinon, la taupe ne pourra pas les trouver. ✋🚫

### 📍 Ajouter les Markers dans la scène principale (ex: `Forest.tscn`)

1. **Ouvre ta scène principale (`Forest.tscn`) qui contient ta taupe (`Mole.tscn`).**  
2. **Fais un clic droit > `Add Child Node` > Recherche `Position2D` > Clique sur `Create`.**  
3. **Renomme-le `Marker_A`.**  
4. **Répète l’opération pour créer un autre `Position2D` nommé `Marker_B`.**  
5. **Positionne `Marker_A` et `Marker_B` aux endroits où tu veux que ta taupe fasse ses allers-retours.**  

💡 **Explication :**  
- Les `Markers` sont des points de repère que ta taupe va utiliser pour savoir où aller.  
- Puisque la taupe n'a pas ces `Markers` dans sa propre scène (`Mole.tscn`), il faut les ajouter **dans la scène principale** où elle est présente.  

---

## 🔍 Étape 4 : Ajouter le Script Principal (Patrouille et Animation)

### 📁 Scripts/Mole.gd

```gdscript
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var vitesse: float = 15.0  

var point_a: Vector2
var point_b: Vector2
var going_to_b: bool = true
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN

func _ready():
    point_a = get_parent().get_node("Marker_A").global_position
    point_b = get_parent().get_node("Marker_B").global_position
    
    if animated_sprite:
        animated_sprite.play("idle_down")
    else:
        print("Erreur : AnimatedSprite2D non trouvé !")

func _physics_process(delta: float) -> void:
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
```

---

## ✅ Teste ton ennemi !

- Place ta taupe (`Mole.tscn`) dans ta scène principale (`Forest.tscn`).  
- Ajoute `Marker_A` et `Marker_B` dans la scène principale.  
- Appuie sur **Play** et observe ! 🎉  

✨ **Bravo !** Ta taupe patrouille entre les points correctement. Et maintenant, elle peut les détecter depuis la scène principale ! 😄
