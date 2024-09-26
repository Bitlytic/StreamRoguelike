extends Node



var channel_count := 5
var current_channel := 0

var stream_players : Array[AudioStreamPlayer] = []


func _ready() -> void:
	for i in channel_count:
		var stream_player := AudioStreamPlayer.new()
		stream_player.bus = "Sound"
		add_child(stream_player)
		stream_players.append(stream_player)


func _get_next_stream() -> AudioStreamPlayer:
	var channel := stream_players[current_channel]
	current_channel += 1
	current_channel %= current_channel
	
	return channel


func play_sound(stream: AudioStream, volume_scale: float = 1.0) -> void:
	var channel := _get_next_stream()
	
	channel.pitch_scale = 1.0
	channel.volume_db = linear_to_db(volume_scale)
	channel.stream = stream
	channel.play()


func play_sound_random_pitch(stream: AudioStream, pitch_range: float = 0.2, volume_scale: float = 1.0) -> void:
	var channel := _get_next_stream()
	
	channel.pitch_scale = 1.0 + randf_range(-pitch_range, pitch_range)
	channel.volume_db = linear_to_db(volume_scale)
	channel.stream = stream
	channel.play()
