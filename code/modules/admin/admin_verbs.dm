//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/client/proc/player_panel,
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
//	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/cmd_mentor_check_new_players,
	/client/proc/checkAccount,
	/client/proc/checkAllAccounts
//	/client/proc/deadchat				/*toggles deadchat on/off*/
	)
var/list/admin_verbs_admin = list(
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/client/proc/colorooc,				/*allows us to set a custom colour for everythign we say in ooc*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
	/client/proc/Jump,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/admin_call_shuttle,	/*allows us to call the emergency shuttle*/
	/client/proc/admin_cancel_shuttle,	/*allows us to cancel the emergency shuttle, sending it back to centcomm*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/check_words,			/*displays cult-words*/
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/client/proc/rename_silicon,		/*properly renames silicons*/
	/client/proc/check_antagonists,
	/client/proc/admin_memo,			/*admin memo system. show/delete/write. +SERVER needed to delete admin memos of others*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/toggleprayers,			/*toggles prayers on/off*/
//	/client/proc/toggle_hear_deadcast,	/*toggles whether we hear deadchat*/
	/client/proc/toggle_hear_radio,		/*toggles whether we hear the radio*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggledsay,		/*toggles dsay on/off for everyone*/
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/PlayerNotes,
	/datum/admins/proc/show_player_info,
	/client/proc/free_slot,			/*frees slot for chosen job*/
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/toggleattacklogs,
	/client/proc/toggledebuglogs,
	/client/proc/toggle_antagHUD_use,
	/client/proc/toggle_antagHUD_restrictions,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/toggledebuglogs,
	/client/proc/view_chemical_reaction_logs
)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans
	)
var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound
	)
var/list/admin_verbs_fun = list(
	/client/proc/object_talk,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
 	/client/proc/everyone_random,
	/client/proc/cinematic,
	/client/proc/one_click_antag,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/send_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/event_manager_panel,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/editappear
	)
var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_fruit,
	/datum/admins/proc/spawn_plant,
	/datum/admins/proc/spawn_atom,		/*allows us to spawn instances*/
	/client/proc/respawn_character,
	/client/proc/virus2_editor,
	/client/proc/add_supply_pack
	)
var/list/admin_verbs_server = list(
	/client/proc/Set_Holiday,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/immreboot,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/toggle_random_events,
	/client/proc/nanomapgen_DumpImage
	)
var/list/admin_verbs_debug = list(
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/kill_air,
	/client/proc/ZASSettings,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/print_random_map,
	/client/proc/create_random_map,
	/client/proc/show_plant_genes,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/toggledebuglogs,
	/client/proc/SDQL_query,
	/client/proc/SDQL2_query,
	/client/proc/Jump,
	/client/proc/jumptomob,
	/client/proc/jumptocoord,
	/client/proc/ToRban,
	/client/proc/dsay,
	/client/proc/invisimin				/*allows our mob to go invisible/visible*/
	)

var/list/admin_verbs_paranoid_debug = list(
	/client/proc/callproc,
	/client/proc/debug_controller
	)

var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)
var/list/admin_verbs_rejuv = list(
	/client/proc/allow_character_respawn,    /* Allows a ghost to respawn */
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/respawn_character
	)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/client/proc/deadmin_self,
//	/client/proc/deadchat,
	/client/proc/toggleprayers,
	/client/proc/toggle_hear_radio,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/announce,
	/client/proc/colorooc,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/check_words,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/object_talk,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/send_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/Set_Holiday,
	/client/proc/ToRban,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/kill_air,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/startSinglo,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_mod = list(
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game.*/
	/client/proc/toggledebuglogs,
	/datum/admins/proc/PlayerNotes,
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/datum/admins/proc/show_player_info,
	/client/proc/player_panel_new,
	/client/proc/dsay,
	/datum/admins/proc/show_player_panel,
	/client/proc/check_antagonists,
	/client/proc/jobbans,
	/client/proc/cmd_admin_subtle_message 	/*send a message to somebody as a 'voice in their head'*/
)

var/list/admin_verbs_mentor = list(
	/client/proc/cmd_admin_pm_context,
	/client/proc/cmd_admin_pm_panel,
	/datum/admins/proc/PlayerNotes,
	/client/proc/admin_ghost,
	/datum/admins/proc/show_player_info,
//	/client/proc/dsay,
	/client/proc/cmd_admin_subtle_message
)

/client/proc/add_admin_verbs()
	if(holder)
		verbs += admin_verbs_default
		if(holder.rights & R_BUILDMODE)		verbs += /client/proc/togglebuildmodeself
		if(holder.rights & R_ADMIN)			verbs += admin_verbs_admin
		if(holder.rights & R_BAN)			verbs += admin_verbs_ban
		if(holder.rights & R_FUN)			verbs += admin_verbs_fun
		if(holder.rights & R_SERVER)		verbs += admin_verbs_server
		if(holder.rights & R_DEBUG)
			verbs += admin_verbs_debug
			if(config.debugparanoid && !(holder.rights & R_ADMIN))
				verbs.Remove(admin_verbs_paranoid_debug)			//Right now it's just callproc but we can easily add others later on.
		if(holder.rights & R_POSSESS)		verbs += admin_verbs_possess
		if(holder.rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(holder.rights & R_STEALTH)		verbs += /client/proc/stealth
		if(holder.rights & R_REJUVINATE)	verbs += admin_verbs_rejuv
		if(holder.rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(holder.rights & R_SPAWN)			verbs += admin_verbs_spawn
		if(holder.rights & R_MOD)			verbs += admin_verbs_mod
		if(holder.rights & R_MENTOR)		verbs += admin_verbs_mentor

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		debug_verbs
		)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs
	src << "<span class='interface'>Most of your adminverbs have been hidden.</span>"
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/cmd_admin_say
	verbs += /client/proc/show_verbs
	src << "<span class='interface'>Almost all of your adminverbs have been hidden.</span>"
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()
	src << "<span class='interface'>All of your adminverbs are now visible.</span>"


/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(istype(mob,/mob/dead/observer))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if(!is_mentor(usr.client))
			ghost.can_reenter_corpse = 1
		if(ghost.can_reenter_corpse)
			ghost.reenter_corpse()
		else
			ghost << "<font color='red'>Error:  Aghost:  Can't reenter corpse, mentors that use adminHUD while aghosting are not permitted to enter their corpse again</font>"
			return

	else if(istype(mob,/mob/new_player))
		src << "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>"
	else
		//ghostize
		var/mob/body = mob
		var/mob/dead/observer/ghost = body.ghostize(1)
		ghost.admin_ghosted = 1
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus


/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			mob << "\red <b>Invisimin off. Invisibility reset.</b>"
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			mob << "\blue <b>Invisimin on. You are now as invisible as a ghost.</b>"
			mob.alpha = max(mob.alpha - 100, 0)


/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_old()
	return

/client/proc/player_panel_new()
	set name = "Player Panel New"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.Jobbans()
		else
			holder.DB_ban_panel()
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	return

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(!holder)	return

	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	prefs.save_preferences()
	return

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", 1)


#define MAX_WARNS 2
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		src << "<font color='red'>Error: warn(): No such ckey found.</font>"
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			C << "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes."
			del(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
	else
		if(C)
			C << "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>"
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [2-D.warns] strikes remaining.")

#undef MAX_WARNS
#undef AUTOBANTIME

/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
			var/light_impact_range = input("Light impact range (in tiles):") as num
			var/flash_range = input("Flash range (in tiles):") as num
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("\blue [ckey] creating an admin explosion at [epicenter.loc].")

/client/proc/give_spell(mob/T as mob in mob_list) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."

	var/list/spell_names = list()
	for(var/v in spells)
	//	"/obj/effect/proc_holder/spell/" 30 symbols ~Intercross21
		spell_names.Add(copytext("[v]", 31, 0))
	var/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spell_names
	if(!S) return
	var/path = text2path("/obj/effect/proc_holder/spell/[S]")
	T.spell_list += new path
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the spell [S].", 1)

/client/proc/give_disease(mob/T as mob in mob_list) // -- Giacom
	set category = "Fun"
	set name = "Give Disease (old)"
	set desc = "Gives a (tg-style) Disease to a mob."

	var/list/disease_names = list()
	for(var/v in diseases)
	//	"/datum/disease/" 15 symbols ~Intercross
		disease_names.Add(copytext("[v]", 16, 0))
	var/datum/disease/D = input("Choose the disease to give to that guy", "ACHOO") as null|anything in disease_names
	if(!D) return
	var/path = text2path("/datum/disease/[D]")
	T.contract_disease(new path, 1)
	log_admin("[key_name(usr)] gave [key_name(T)] the disease [D].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the disease [D].", 1)

/client/proc/give_disease2(mob/T as mob in mob_list) // -- Giacom
	set category = "Fun"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."

	var/datum/disease2/disease/D = new /datum/disease2/disease()

	var/severity = 1
	var/greater = input("Is this a lesser, greater, or badmin disease?", "Give Disease") in list("Lesser", "Greater", "Badmin")
	switch(greater)
		if ("Lesser") severity = 1
		if ("Greater") severity = 2
		if ("Badmin") severity = 99

	D.makerandom(severity)
	D.infectionchance = input("How virulent is this disease? (1-100)", "Give Disease", D.infectionchance) as num

	if(istype(T,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = T
		if (H.species)
			D.affected_species = list(H.species.name)
	if(istype(T,/mob/living/carbon/monkey))
		var/mob/living/carbon/monkey/M = T
		D.affected_species = list(M.greaterform)
	infect_virus2(T,D,1)

	log_admin("[key_name(usr)] gave [key_name(T)] a [greater] disease2 with infection chance [D.infectionchance].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] a [greater] disease2 with infection chance [D.infectionchance].", 1)

/client/proc/make_sound(var/obj/O in world) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"

	if(O)
		var/message = input("What do you want the message to be?", "Make Sound") as text|null
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound")
		message_admins("\blue [key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound", 1)


/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)

/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)

/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"

	if(air_processing_killed)
		air_processing_killed = 0
		usr << "<b>Enabled air processing.</b>"
	else
		air_processing_killed = 1
		usr << "<b>Disabled air processing.</b>"
	log_admin("[key_name(usr)] used 'kill air'.")
	message_admins("\blue [key_name_admin(usr)] used 'kill air'.", 1)

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.")
		message_admins("[src] re-admined themself.", 1)
		src << "<span class='interface'>You now have the keys to control the planet, or atleast a small space station</span>"
		verbs -= /client/proc/readmin_self

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can't re-admin yourself without someont promoting you.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			src << "<span class='interface'>You are now a normal player.</span>"
			verbs |= /client/proc/readmin_self

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/rename_silicon(mob/living/silicon/S in world)
	set name = "Rename Silicon"
	set category = "Admin"

	if(holder && istype(S))
		var/new_name = trim_strip_input(src, "Enter new name. Leave blank or as is to cancel.", "Enter new silicon name", S.real_name)
		if(new_name && new_name != S.real_name)
			admin_log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
			S.SetName(new_name)


//---- bs12 verbs ----

/client/proc/editappear(mob/living/carbon/human/M as mob in world)
	set name = "Edit Appearance"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	if(!istype(M, /mob/living/carbon/human))
		usr << "\red You can only do this to humans!"
		return
	var/datum/species/S = M.species
	if(!S) S = all_species["Human"]

	switch(alert("Are you sure you wish to edit this mob's appearance? Skrell, Unathi, Vox and Tajaran can result in unintended consequences.",,"Yes","No"))
		if("No")
			return
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.facial_r = hex2num(copytext(new_facial, 2, 4))
		M.facial_g = hex2num(copytext(new_facial, 4, 6))
		M.facial_b = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.hair_r = hex2num(copytext(new_hair, 2, 4))
		M.hair_g = hex2num(copytext(new_hair, 4, 6))
		M.hair_b = hex2num(copytext(new_hair, 6, 8))

	if(S.flags & HAS_EYE_COLOR)
		var/new_eyes = input("Please select eye color.", "Character Generation") as color
		if(new_eyes)
			M.eyes_r = hex2num(copytext(new_eyes, 2, 4))
			M.eyes_g = hex2num(copytext(new_eyes, 4, 6))
			M.eyes_b = hex2num(copytext(new_eyes, 6, 8))

	if(S.flags & HAS_SKIN_COLOR)
		var/new_skin = input("Please select body color. This is for Tajaran, Unathi, and Skrell only!", "Character Generation") as color
		if(new_skin)
			M.skin_r = hex2num(copytext(new_skin, 2, 4))
			M.skin_g = hex2num(copytext(new_skin, 4, 6))
			M.skin_b = hex2num(copytext(new_skin, 6, 8))

	if(S.flags & HAS_SKIN_TONE)
		var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text
		if (new_tone)
			M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
			M.s_tone =  -M.s_tone + 35

	// hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
			M.body_build = 0
		else
			M.gender = FEMALE
			if(!S.allow_slim_fem)
				M.body_build = 0
			else // If slim body allowed
				var/new_body_build = alert(usr, "Please select body build.", "Character body build", "Default", "Slim")
				if (new_body_build)
					if(new_body_build == "Slim")
						M.body_build = 1
					else
						M.body_build = 0

	M.dna.ResetUIFrom(M)
	M.update_hair()
	M.update_body()
	M.check_dna(M)

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in job_master.occupations)
			if (J.current_positions >= J.total_positions && J.total_positions != -1)
				jobs += J.title
		if (!jobs.len)
			usr << "There are no fully staffed jobs."
			return
		var/job = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		if (job)
			job_master.FreeRole(job)
			message_admins("A job slot for [job] has been opened by [key_name_admin(usr)]")
			return

/client/proc/toggleattacklogs()
	set name = "Toggle Attack Log Messages"
	set category = "Preferences"

	prefs.toggles ^= CHAT_ATTACKLOGS
	if (prefs.toggles & CHAT_ATTACKLOGS)
		usr << "You now will get attack log messages"
	else
		usr << "You now won't get attack log messages"

/client/proc/toggledebuglogs()
	set name = "Toggle Debug Log Messages"
	set category = "Preferences"

	prefs.toggles ^= CHAT_DEBUGLOGS
	if (prefs.toggles & CHAT_DEBUGLOGS)
		usr << "You now will get debug log messages"
	else
		usr << "You now won't get debug log messages"

/client/proc/add_supply_pack()
	set category = "Fun"
	set name = "Add supply pack"
	set desc = "Add custom supply pack, it will be available in cargo"

	/*var/datum/custom_pack_generator/CPG = new()
//	supply_controller.custom_supply_packs_generators[usr.name] = CPG
	CPG.interact( usr )*/

	if( !src.holder ) return
	var/obj/structure/closet/MD = src.holder.marked_datum
	if( (src.holder.marked_datum==null) || !istype( MD ))
		alert( "You must select any object with type \"/obj/structure/closet\" as \"Marked object\" ( VV-> mark object) before we can start", "Error", "Ok" )
		return

	var/name = "Custom supply pack"
	var/cost = 8
	var/price = 0
	var/access = MD:req_access?MD:req_access[1]:0
	var/containername = MD.name
	var/containertype = MD.type
	var/group = "Operations"
	var/hide = 0
	var/contains = list()
	var/error = 1

	for( var/atom/movable/AM in MD.contents )
		contains += AM.type

	while( error )
		name = input( "Enter supply pack new name\nIt will be displayed in cargo cosole\nNo name for exit", "Name", name ) as text|null
		var/clear_name = reject_bad_name(name, 1, 50)
		if( !name == clear_name )
			if(alert("Inputed name have bad symbols! New name is [clear_name]", "Warning", "Ok", "Enter new name") == "Ok")
				name = clear_name
			else
				continue
		if( !name && alert( "Name is requied!", "Error", "Retry", "Abort") == "Abort") return
		else if( supply_controller.supply_packs.Find(name) )
			if (alert( "Name must be unic!", "Error", "Retry", "Abort") == "Abort") return
		else
			error = 0

	error = 1
	while( error )
		cost = input( "Enter supply pack new cost (in supply points)\nIt must be >= 8", "Cost", cost) as num|null
		if( cost >= 8 ) error = 0
		else if (alert( "Cost must be >= 8!", "Error", "Retry", "Abort") == "Abort") return

	error = 1
	while( error )
		access = input( "Enter req access level (sorry only digit form for now).\nSee code/game/jobs/access.dm for help", "Access", access) as num|null
		if( access >= 0 ) error = 0
		else if (alert( "Access can't be < 0", "Error", "Retry", "Abort") == "Abort") return

	group = input( "Select group for pack", "Group", group) in all_supply_groups

	hide = alert( "Pack must be visiable only in hacked console?", "Hide", "No", "Yes")=="Yes" ? 1 : 0

	var/datum/supply_packs/custom/CP = new( \
		name, cost, price, access, containername, \
		containertype, group, hide, contains )

	if( supply_controller.supply_packs.Find(name) ) log_debug("Supply pack [name] already exist!")
	else
		supply_controller.supply_packs[name] = CP
		usr << "Supply pack [name] successfully created!"
		log_admin("[key_name(usr)] has add custom supply pack [name]")