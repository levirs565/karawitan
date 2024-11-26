extends Area2D;

var audio_stream: AudioStreamPlayer2D
var key_shade: Polygon2D
var key_shape: CollisionShape2D

func _ready() -> void:
	audio_stream = get_node("KeyAudio")
	key_shade = get_node("KeyShade")
	key_shape = get_node("KeyShape")

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
	audio_stream.play(0.0);

func _process(delta: float) -> void:
	pass	

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		play();
	pass
