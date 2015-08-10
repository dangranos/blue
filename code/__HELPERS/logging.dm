//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"

/proc/log_admin(text)
	admin_log.Add(text)
	diary << "\[[time_stamp()]]ADMIN: [text][log_end]"


/proc/log_debug(text)
	diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text]"


/proc/log_game(text)
	diary << "\[[time_stamp()]]GAME: [text][log_end]"

/proc/log_vote(text)
	diary << "\[[time_stamp()]]VOTE: [text][log_end]"

/proc/log_access(text)
	diary << "\[[time_stamp()]]ACCESS: [text][log_end]"

/proc/log_say(text)
	diary << "\[[time_stamp()]]SAY: [text][log_end]"

/proc/log_ooc(text)
	diary << "\[[time_stamp()]]OOC: [text][log_end]"

/proc/log_whisper(text)
	diary << "\[[time_stamp()]]WHISPER: [text][log_end]"

/proc/log_emote(text)
	diary << "\[[time_stamp()]]EMOTE: [text][log_end]"

/proc/log_attack(text)
	diary << "\[[time_stamp()]]ATTACK: [text][log_end]" //Seperate attack logs? Why?  FOR THE GLORY OF SATAN!

/proc/log_adminsay(text)
	diary << "\[[time_stamp()]]ADMINSAY: [text][log_end]"

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << "\[[time_stamp()]]ADMINWARN: [text][log_end]"

/proc/log_pda(text)
	diary << "\[[time_stamp()]]PDA: [text][log_end]"

/proc/log_misc(text)
	diary << "\[[time_stamp()]]MISC: [text][log_end]"

//pretty print a direction bitflag, can be useful for debugging.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")
