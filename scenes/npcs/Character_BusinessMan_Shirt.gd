extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_texture(png_path):
	var image = Image.load_from_file(png_path)
	var texture = ImageTexture.create_from_image(image)

	var material = get_active_material(0) as StandardMaterial3D;
	material.albedo_texture = texture.duplicate()
