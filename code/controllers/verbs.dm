//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/print_random_map()
	set category = "Debug"
	set name = "Display Random Map"
	set desc = "Show the contents of a random map."

	if(!holder)	return

	var/datum/random_map/choice = input("Choose a map to debug.") as null|anything in random_maps
	if(!choice)
		return
	choice.display_map(usr)


/client/proc/create_random_map()
	set category = "Debug"
	set name = "Create Random Map"
	set desc = "Create a random map."

	if(!holder)	return

	var/map_datum = input("Choose a map to create.") as null|anything in typesof(/datum/random_map)-/datum/random_map
	if(!map_datum)
		return
	var/seed = input("Seed? (default null)")  as text|null
	var/tx =    input("X? (default 1)")       as text|null
	var/ty =    input("Y? (default 1)")       as text|null
	var/tz =    input("Z? (default 1)")       as text|null
	new map_datum(seed,tx,ty,tz)

/client/proc/restart_controller(controller in list("Master","Failsafe","Lighting","Supply"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	usr = null
	src = null
	switch(controller)
		if("Master")
			new /datum/controller/game_controller()
			master_controller.process()
		if("Failsafe")
			new /datum/controller/failsafe()
		if("Lighting")
			new /datum/controller/lighting()
			lighting_controller.process()
		if("Supply")
			supply_controller.process()
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return

/client/proc/debug_controller(controller in list("Master","Failsafe","Ticker","Lighting","Air","Jobs","Sun",\
								"Radio","Supply","Shuttles","Emergency Shuttle","Configuration","pAI", "Cameras",\
								"Transfer Controller", "Vote", "Gas Data","Event","Plants","Alarm","Nano"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
		if("Failsafe")
			debug_variables(Failsafe)
		if("Ticker")
			debug_variables(ticker)
		if("Lighting")
			debug_variables(lighting_controller)
		if("Air")
			debug_variables(air_master)
		if("Jobs")
			debug_variables(job_master)
		if("Sun")
			debug_variables(sun)
		if("Radio")
			debug_variables(radio_controller)
		if("Supply")
			debug_variables(supply_controller)
		if("Shuttles")
			debug_variables(shuttle_controller)
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
		if("Configuration")
			debug_variables(config)
		if("pAI")
			debug_variables(paiController)
		if("Cameras")
			debug_variables(cameranet)
		if("Transfer Controller")
			debug_variables(transfer_controller)
		if("Vote")
			debug_variables(vote)
		if("Gas Data")
			debug_variables(gas_data)
		if("Event")
			debug_variables(event_manager)
		if("Plants")
			debug_variables(plant_controller)
		if("Alarm")
			debug_variables(alarm_manager)
		if("Nano")
			debug_variables(nanomanager)
		if("Jobs")
			debug_variables(job_master)
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
