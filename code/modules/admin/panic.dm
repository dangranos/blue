/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"
	if (!config.sql_enabled)
		usr << "<span class='adminnotice'>The Database is not enabled!</span>"
		return

	if (!dbcon || !dbcon.IsConnected())
		usr << "<span class='adminnotice'>The Database is not connected!</span>"
		return

	log_admin("[key_name(usr)] has toggled the Panic Bunker")
	message_admins("[key_name_admin(usr)] has toggled the Panic Bunker")