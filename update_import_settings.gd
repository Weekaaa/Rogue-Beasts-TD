@tool
extends EditorScript

func _run():
	var dir = DirAccess.open("res://Ninja Adventure - Asset Pack")  # Adjust this path to your image directory
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				var file_path = "res://Ninja Adventure - Asset Pack/" + file_name
				update_import_settings(file_path)
			file_name = dir.get_next()
		dir.list_dir_end()
		print("Import settings updated for all images in the directory.")
	else:
		print("Failed to open directory: res://Ninja Adventure - Asset Pack")

func update_import_settings(file_path):
	var texture = load(file_path)
	if texture and texture is ImageTexture:
		var options = {
			"compress/mode": "Lossless",
			"flags/filter": 0,  # Nearest filtering
			"flags/mipmaps": 0,  # Disable mipmaps
			"flags/srgb": false  # Disable SRGB if not needed
		}
		save_resource(texture, file_path, options)

func save_resource(resource, path, options):
	var config = {
		"importer": "texture",
		"import_path": path,
		"options": options,
		"reimport": true
	}
	ResourceSaver.save(resource, path, config)
