extends Control

var key_nodes = Array()
var last_input_time = Array()

func _ready() -> void:
	for i in range(1, 8):
		key_nodes.push_back(get_node("Saron/SaronKey%d" % i));
		last_input_time.push_back(0);
		
	for node in key_nodes:
		node.highlight(false);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(key_nodes.size()):
		var last = last_input_time[i];
		var can_press = last == 0 or Time.get_ticks_msec() - last >= 250;
		if can_press and Input.is_key_pressed(KEY_1 + i):
			key_nodes[i].play();
			last_input_time[i] = Time.get_ticks_msec();
