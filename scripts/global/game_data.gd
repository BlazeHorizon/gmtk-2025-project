extends Node

signal launch_train_cars

var player_info: PlayerInfo = PlayerInfo.new()

func _ready():
	player_info.base_stats = LaunchStats.new(
		1.0, 1.0, 0.0, 1.0, 10.0, 100.0, 100.0, 0.0, 0.0, 0.0
	)
	# TODO: we need to link these part objects to actual scen parts
	# and set up placing tracks/linking carts, below is example code to add
	# placed_tracks and linked_carts
	
	## if you want to test you can uncomment this section
	## example adding a placed_track:
	#player_info.placed_tracks.append(
		## currently only adding raondom parts works
		#TrackFactory.get_random_track_by_rarity(0)
	#)
	
	## if you want to test you can uncomment this section
	## example adding a placed_track:
	#player_info.linked_carts.append(
		## currently only adding raondom parts works
		#CartFactory.get_random_cart_by_rarity(0)
	#)
	
	# TODO: in the files where you add the different parts, this line
	# can be run to calculate what the final launch stats will be, you can
	# call this every time a new part is placed/linked and/or run it again before launch:
	#player_info.calculate_final_launch_stats()
	
	# # TODO: in post launch games when you want to reference the stats you can use this:
	# GameData.player_info.current_stats # followed by your property to you want to use
	
	# === TRACKS ===
	# Example: Add a random track from the TrackFactory (rarity 0)
	var test_track = TrackFactory.get_random_track_by_rarity(0)
	player_info.owned_tracks.append(test_track)
	player_info.placed_tracks.append(test_track)

	# === CARTS ===
	# Example: Add a random cart from the CartFactory (rarity 0)
	var test_cart = CartFactory.get_random_cart_by_rarity(0)
	player_info.owned_carts.append(test_cart)
	player_info.linked_carts.append(test_cart)

	# Calculate final launch stats after all parts are placed/linked
	var final_stats = player_info.calculate_final_launch_stats()
	print("Final Launch Stats:")
	print("Speed: ", final_stats.speed)
	print("Acceleration: ", final_stats.acceleration)

	# === USAGE EXAMPLE ===
	# Access calculated stats during launch or gameplay:
	var launch_speed = player_info.current_stats.speed
	var launch_force = player_info.current_stats.acceleration
	print("Using launch speed: ", launch_speed)
	print("Using launch force: ", launch_force)
