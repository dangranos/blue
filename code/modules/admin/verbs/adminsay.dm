/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(0))	return

	msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
	if(!msg)	return

	log_admin("ASAY: [key_name(src)] : [msg]")
	admins << "<span class='admin_channel'><span class='prefix'>ADMIN:</span> <span class='name'>[key_name(usr, 1)]</span>(<a href='?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
