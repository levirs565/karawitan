extends Area2D;

var audio_stream: AudioStreamPlayer2D
var key_shade: Polygon2D
var key_shape: CollisionShape2D
var key_num: int = 0
var on_play_listener = null
var last_input_time = 0

func _ready() -> void:
	audio_stream = get_node("KeyAudio")
	key_shade = get_node("KeyShade")
	key_shape = get_node("KeyShape")
	key_num = get_meta("key_number")

	if key_shape.shape is RectangleShape2D:
		var hw = key_shape.shape.size.x / 2;
		var hh = key_shape.shape.size.y / 2;
		var points = Array();
		points.append(Vector2(-hw, -hh));
		points.append(Vector2(hw, -hh));
		points.append(Vector2(hw, hh));
		points.append(Vector2(-hw, hh));
		points.append(Vector2(-hw, -hh));
		key_shade.polygon = PackedVector2Array(points);

func highlight(show: bool):
	key_shade.visible = show;

func play():
	if on_play_listener:
		on_play_listener.call(key_num)
	audio_stream.play(0.0);

func _process(delta: float) -> void:
	var can_press = last_input_time == 0 or Time.get_ticks_msec() - last_input_time >= 250;
	if can_press and Input.is_key_pressed(KEY_0 + key_num):
		play();
		last_input_time = Time.get_ticks_msec();

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		play();
	pass
