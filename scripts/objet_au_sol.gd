extends Area2D

# On garde ton export actuel
@export var objet_data : Objet 
# On ajoute une taille de référence (64px au sol par exemple)
@export var taille_voulue : float = 64.0
signal ramassage()

func _ready():
	if objet_data:
		var sprite = $Sprite2D
		sprite.texture = objet_data.icone
		
		# --- LOGIQUE DE REDIMENSIONNEMENT ---
		if sprite.texture:
			var taille_image = sprite.texture.get_size()
			# On cherche le côté le plus grand pour garder le ratio
			var max_cote = max(taille_image.x, taille_image.y)
			
			# On calcule l'échelle (ex: 64 / 2000 = 0.032)
			var ratio = taille_voulue / max_cote
			sprite.scale = Vector2(ratio, ratio)
			
			# --- AJUSTEMENT DE LA COLLISION ---
			# On ajuste le carré bleu à la taille voulue (32 de rayon pour 64 de large)
			if has_node("CollisionShape2D"):
				var shape_node = $CollisionShape2D
				if shape_node.shape is RectangleShape2D:
					shape_node.shape.size = Vector2(taille_voulue, taille_voulue)
		
		print("Texture chargée et redimensionnée : ", objet_data.nom)
	else:
		push_warning("Oups ! Tu as oublié de glisser une ressource .tres dans cet objet.")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("click")
		var joueur = get_tree().get_first_node_in_group("joueur")
		if joueur:
			joueur.aller_ramasser(self)
		
