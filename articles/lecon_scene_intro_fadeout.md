# 🌟 Créer une scène d'intro avec texte et animation fade-out dans Godot 4.4

Bienvenue dans ce tutoriel , spécialement fait pour toi, qui débutes sur Godot et souhaites créer une jolie scène d'introduction immersive avec une petite histoire et une animation douce en fade-out ! 🎮✨

## 🎯 Ce que tu vas réaliser :

- Une scène avec un fond noir
- Un texte qui raconte une petite histoire d'introduction
- Le texte disparaît doucement pour laisser place à ton jeu principal

---

## 📦 Structure finale de ta scène :

Voici exactement la structure dont tu as besoin :

```
Intro (Control, Layout : Full Rect)
├── ColorRect (fond noir fixe)
├── Label (texte blanc)
└── AnimationPlayer
```

> ⚠️ **Attention au piège du Panel !**  
> Ne mets surtout **PAS** ton Label dans un Panel, sinon tu vas obtenir un effet gris bizarre lors du fade-out.  
> Pourquoi ? Parce qu'un Panel a par défaut une couleur de fond qui apparaît dès que tu animes sa transparence.

---

## 🛠️ Étape 1 : Créer la scène de base

- Crée une nouvelle scène `Control` (Layout : Full Rect)
- Ajoute dedans :
  - Un **ColorRect** (Layout : Full Rect, Couleur : noir pur `#000000`)
  - Un **Label** (texte blanc, centré, mets ton histoire dedans)
  - Un **AnimationPlayer** (pour gérer l'animation)

Tu devrais avoir précisément :

```
Intro (Control)
├─ ColorRect (Noir)
├─ Label (Texte blanc)
└─ AnimationPlayer
```

---

## 🎨 Étape 2 : Le texte personnalisable depuis l'éditeur

Ajoute ce petit script à ton node **Intro** :

```gdscript
extends Control

@export_file("*.tscn") var next_scene_path: String
@export_multiline var intro_text: String = "Écris ton histoire ici..."

@onready var animation_player = $AnimationPlayer
@onready var label = $Label

func _ready():
	label.text = intro_text
	await get_tree().create_timer(3.0).timeout
	animation_player.play("fade_out")
	await animation_player.animation_finished

	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		push_warning("⚠️ Aucun chemin de scène spécifié pour la transition !")
```

✅ **Pourquoi utiliser `[export_multiline]` ?**  
Ça te permet de saisir confortablement ton histoire directement dans l'éditeur Godot, sur plusieurs lignes !

---

## 🎬 Étape 3 : Créer une animation de fade-out du texte

1. Clique sur **AnimationPlayer**.
2. En bas de l'écran, clique sur `Animation → New`, appelle-la `fade_out`, durée : 2 sec.
3. Clique sur ton **Label** :

   - Dans l'inspecteur, clique sur la petite clé 🗝️ près de la propriété **Modulate** → "Create" (clé à 0 sec).
   - Laisse par défaut (255,255,255,255).

4. Clique à **2 sec** sur la timeline :
   - Change l'Alpha du **Label** (A) à 0 (transparent).
   - Clique sur la clé 🗝️ pour créer la deuxième clé.

Maintenant ton animation est :

- `0 sec` : Label visible (255,255,255,255)
- `2 sec` : Label transparent (255,255,255,0)

Test : ▶️ Play, ton texte disparaît en douceur !

---

## 🚩 Le piège à éviter : le Panel !

Si tu avais utilisé un Panel pour ton texte, le fond gris clair du Panel aurait réapparu en transparence et causé un effet gris désagréable.

❌ **À ne PAS faire :**

```
Intro
├── ColorRect
├── Panel ❌ (fond gris clair par défaut)
│   └── Label
└── AnimationPlayer
```

✅ **Ce qu'il FAUT faire (correct) :**

```
Intro
├── ColorRect ✅ (Fond noir)
├── Label ✅ (Texte directement ici)
└── AnimationPlayer ✅
```

---

## 🚀 Étape 4 : Utilisation finale

Dans l'inspecteur Godot, remplis simplement :

- `intro_text` avec ta jolie histoire
- `next_scene_path` avec le chemin vers ta scène principale.

**Lance ta scène Intro :**  
Ton texte apparaît, reste visible 3 secondes, puis disparaît doucement laissant place à ta scène principale.

✨ Bravo, tu as réussi ta scène d'intro parfaitement !

---

## 🌈 Astuces Bonus :

- Tu peux ajuster facilement la durée de pause avant l'animation (`3.0` sec dans le script).
- Ajoute une petite musique douce pour renforcer l'immersion.
- Cette scène d'intro est réutilisable à l'infini pour différents moments de ton jeu, avec d'autres textes !

---
