extends Area2D

@export var poids = randi_range(15,180)
@export var apporte_faim : float = 20.0
func _ready():
	rotation = randf_range(0,TAU)
	print(poids)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# On empêche le clic de traverser vers le sol
			get_viewport().set_input_as_handled()
			
			# On trouve le joueur dans la scène et on lui donne l'ordre
			# (Assure-toi que ton personnage s'appelle bien "Joueur" dans l'arbre)
			var joueur = get_tree().current_scene.find_child("Joueur", true, false)
			if joueur:
				joueur.aller_ramasser(self)
func _on_mouse_entered() -> void:
	# On accède au shader du Sprite et on met l'épaisseur à 1.5 pixel
	$Sprite2D.material.set_shader_parameter("line_thickness", 10.5)

func _on_mouse_exited() -> void:
	# On remet l'épaisseur à 0 pour faire disparaître le contour
	$Sprite2D.material.set_shader_parameter("line_thickness", 0.0)
'''
#autre option plus "simple" que le shader
func _on_mouse_entered() -> void:
	modulate = Color(1.5,1.5,1.5)


func _on_mouse_exited() -> void:
	modulate = Color(1,1,1)
'''
