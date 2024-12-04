extends Control

var timer: Timer
var key_nodes = Array()
var highlighted_num: int = 0
var gending_state = "PAUSED";
var gending_data = null
var gending_event_index = -1

func _ready() -> void:
	timer = get_node("Timer");
	
	for i in range(1, 8):
		key_nodes.push_back(get_node("Saron/SaronKey%d" % i));
		
	for node in key_nodes:
		node.on_play_listener = Callable(self, "_on_key_play")
		node.highlight(false);
	
	var file = FileAccess.open("res://gending/gugur_gunung.json", FileAccess.READ)
	var json = JSON.new()
	json.parse(file.get_as_text(true))
	
	gending_data = json.data
	
	timer.start()


func highlight(num: int):
	if highlighted_num != 0:
		key_nodes[highlighted_num - 1].highlight(false)
	highlighted_num = num
	if highlighted_num != 0:
		key_nodes[highlighted_num - 1].highlight(true)

func _process(delta: float) -> void:
	pass

func _on_key_play(key_num):
	if gending_state != "STARTED":
		return
	
	var event = gending_data.event[gending_event_index] 
	if event.type == "key" and event.value == key_num:
		highlight(0)
		timer.start() 

func _on_timer_timeout() -> void:
	gending_event_index += 1
	if gending_event_index > gending_data.event.size():
		gending_state = "STOPPED"
		return
	
	gending_state = "STARTED";
	while gending_event_index < gending_data.event.size():
		var event = gending_data.event[gending_event_index]
		if event.type == "delay":
			timer.start()
			break
		if event.type == "key":
			highlight(event.value)
			break
		gending_event_index += 1


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn");
