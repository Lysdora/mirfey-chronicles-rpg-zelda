
# 💥 Guide Détaillé : Implémenter un Système de Dégâts (HurtyBox, GameState & HUD)

Ici, on va apprendre à faire en sorte que notre taupe puisse **infliger des dégâts à Elara** ! 🦦💥 On va aussi connecter ce système à un **HUD qui affiche des cœurs**, pour bien voir la vie restante. C'est parti ! 🚀

---

## 🎯 Objectif
- Créer un système de dégâts où l'ennemi peut blesser Elara. 🔥
- Afficher la santé d’Elara avec des cœurs sur l’écran. ❤️

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

## 🔍 Étape 2 : Créer la Scène HUD (Affichage des Cœurs)

🎯 Ici, tu vas créer une **interface utilisateur (HUD)** qui affiche les cœurs représentant la vie d’Elara.

### 📁 Scène HUD (UI)
1. **Crée une nouvelle scène** (clic droit dans ton dossier `Scenes` > `New Scene` > `Other Node` > `CanvasLayer`).  
2. **Renomme-la en `HUD`**.
3. **Ajoute un `Control`** en tant qu’enfant du `HUD` et renomme-le `HeartContainer`. C’est lui qui va contenir tous les cœurs.  
4. **Ajoute un `HBoxContainer` ou `Node2D`** nommé `Hearts` en tant qu’enfant de `HeartContainer`.  
5. **Ajoute des `TextureRect` dans `Hearts`** (par exemple `Heart1`, `Heart2`, `Heart3`).  

📌 **Astuce** : Pour aligner facilement les cœurs, utilise un `HBoxContainer`.

### 💡 Subtilité : Utiliser un Atlas si ton sprite n’est pas découpé
Si tu as un **sprite qui contient plusieurs images (comme une sprite sheet de cœurs)**, utilise un `AtlasTexture` :  
1. **Importe ton sprite complet** (par exemple `hearts.png`).  
2. **Crée une nouvelle `AtlasTexture`** (clic droit > New Resource > AtlasTexture).  
3. **Définis l’image source (`Atlas`) sur ton sprite complet**.  
4. **Définis la région** correspondant au cœur plein (par exemple `16x16 px`).  
5. **Répète pour chaque cœur (plein et vide)**.  

📌 Cela permet de **n’afficher qu’une partie spécifique d’une image complète**.

---

## 🔍 Étape 3 : Script du HUD

Maintenant, on va écrire un script pour mettre à jour les cœurs affichés en fonction de la santé d’Elara.

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
- **`heart_full` / `heart_empty`** : Ce sont les textures représentant un cœur plein et un cœur vide.  
- **`update_hearts()`** : Met à jour chaque cœur selon la vie actuelle d’Elara.  
- **Signal `health_changed`** : Le HUD se met à jour automatiquement quand Elara perd de la vie !  

---

## 🔍 Étape 4 : Tester ton HUD !

- **Ajoute la scène `HUD` dans ton niveau principal (par exemple `Forest.tscn`).**  
- **Lance ton jeu !** Les cœurs doivent s'afficher correctement en haut de l'écran. ❤️

---

## ✅ Teste ton système de dégâts !

1. 🦦 Fais en sorte que ta taupe puisse toucher Elara.  
2. ❤️ Observe les cœurs diminuer à chaque attaque.  
3. 📢 Ajoute des sons, des effets visuels, tout ce que tu veux !

✨ **Bravo !** Tu as maintenant un système de dégâts fonctionnel avec une interface super cool ! 😎🎉

Prochaine étape : Faire en sorte qu’Elara puisse se défendre. 🔥💪
