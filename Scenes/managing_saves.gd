extends Node

const save_path = "user://savegame.tres"

func save_game(data: GameSave):
	var result = ResourceSaver.save(data, save_path)
	if result == OK:
		print("Game saved successfully!")

func load_game() -> GameSave:
	if ResourceLoader.exists(save_path):
		return ResourceLoader.load(save_path)
	return GameSave.new()

func delete_save():
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("Save file deleted.")
