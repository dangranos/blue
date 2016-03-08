#define PAGE_RECORDS	1
#define PAGE_LIMBS		2
#define PAGE_OCCUPATION	3
#define PAGE_LOADOUT	4
#define PAGE_SILICON	5
#define PAGE_PREFS		6

datum/preferences
	var/global/list/setup_pages = list(
		"General"     = PAGE_RECORDS,\
		"Augmentation"= PAGE_LIMBS,\
		"Occupations" = PAGE_OCCUPATION,\
		"Loadout"     = PAGE_LOADOUT,\
		"Silicon"     = PAGE_SILICON,\
		"Preferences" = PAGE_PREFS,\
		)
	var/global/list/r_organs = list("head"="Head", "r_arm"="Right arm", "r_hand"="Right hand",\
			"chest"="Body", "r_leg"="Right Leg", "r_foot"="Right foot")
	var/global/list/l_organs = list("eyes"="Eyes", "l_arm"="Left arm", "l_hand"="Left hand",\
			"groin"="Groin", "l_leg"="Left Leg", "l_foot"="Left foot")
	var/global/list/internal_organs = list("heart"="Heart", "lungs"="Lungs", "liver"="Liver")
	var/global/parents_list = list("r_hand"="r_arm", "l_hand"="l_arm", "r_foot"="r_leg", "l_foot"="l_leg")
	var/global/children_list = list("r_arm"="r_hand", "l_arm"="l_hand", "r_leg"="r_foot", "l_leg"="l_foot")

	var/hair_color   = "#000000"
	var/facial_color = "#000000"
	var/eyes_color   = "#000000"
	var/skin_color   = "#000000"
	var/skin_tone    = 35			//TODO: -s_tone + 35.
	var/current_organ= "chest"
	var/current_page = PAGE_RECORDS

	var/list/modifications_data   = list()
	var/list/modifications_colors = list()

/datum/preferences/proc/NewShowChoices(mob/user)
	if(!user || !user.client)	return
	new_update_preview_icon()

	user << browse_rsc(preview_south, "new_previewicon[SOUTH].png") // TODO: return to list of dirs?
	user << browse_rsc(preview_north, "new_previewicon[NORTH].png")
	user << browse_rsc(preview_east,  "new_previewicon[EAST].png")
	user << browse_rsc(preview_west,  "new_previewicon[WEST].png")

	var/dat = "<html><head><script language='javascript'>function set(param, value)"
	dat += "{window.location='byond://?src=\ref[src];'+param+'='+value;}</script>"
	dat += "<style>span.box{display: inline-block; width: 20px; height: 10px; border:1px solid #000;}"
	dat += "td{padding: 0px}</style></head><body><center>"

	if(path)
		dat += "Slot - "
		dat += "<span onclick=\"set('preference', 'open_load_dialog')\">Load slot</span> - "
		dat += "<span onclick=\"set('preference', 'save')\">Save slot</span> - "
		dat += "<span onclick=\"set('preference', 'reload')\">Reload slot</span><hr>"
	else
		dat += "Please create an account to save your preferences.<hr>"

	// Page switching
	for(var/item in setup_pages)
		if(item!=setup_pages[1])
			dat += " | "
		if(current_page == setup_pages[item])
			dat += "<b>[item]</b>"
		else
			dat += "<span onclick=\"set('switch_page', '[setup_pages[item]]')\">[item]</span>"
	dat += "</center><hr>"

	switch(current_page)
		if(PAGE_RECORDS)	dat+=GetRecordsPage()
		if(PAGE_LIMBS)		dat+=GetLimbsPage()
		if(PAGE_OCCUPATION)	dat+=GetOccupationPage()
		if(PAGE_SILICON)	dat+=GetSiliconPage()
		if(PAGE_PREFS)		dat+=GetPrefsPage()
		if(PAGE_LOADOUT)	dat+=GetLoadOutPage()
		else dat+=GetRecordsPage() // Protection
	dat += "</body></html>"

	user << browse(dat, "window=preferences;size=550x500;can_resize=0")

/datum/preferences/Topic(href, href_list)
	var/mob/new_player/user = usr
	if(!user || !istype(user) || user.ready)
		return

	if(href_list["switch_page"])
		current_page = text2num(href_list["switch_page"])
		spawn(2)
			NewShowChoices(user)
		return
/*
	if(href_list["preference"])
		if("open_load_dialog")
			if(!IsGuestKey(user.key))
				spawn(2)
					open_load_dialog(user)

		if("close_load_dialog")
			close_load_dialog(user)

		if("changeslot")
			load_character(text2num(href_list["num"]))
			close_load_dialog(user)*/

	switch(current_page)
		if(PAGE_RECORDS)	HandleRecordsTopic(user, href_list)
		if(PAGE_LIMBS)		HandleLimbsTopic(user, href_list)
		if(PAGE_LOADOUT)	HandleLoadOutTopic(user, href_list)
		if(PAGE_OCCUPATION)	HandleOccupationTopic(user, href_list)
		if(PAGE_SILICON)	HandleSiliconTopic(user, href_list)
		if(PAGE_PREFS)		HandlePrefsTopic(user, href_list)

	spawn()
		NewShowChoices(user)
	return


/datum/preferences/proc/GetRecordsPage()
	var/dat = "<table><tr><td width='340px'>"
	dat += "<b>General Information</b><br>"
	dat += "Name: <a href='byond://?src=\ref[src];name=input'>[real_name]</a><br>"
	dat += "(<a href='byond://?src=\ref[src];name=random'>Random Name</a>) "
	dat += "(<a href='byond://?src=\ref[src];name=random_always'>Always Random Name: [random_name ? "Yes" : "No"]</a>)"
	dat += "<br>"

	dat += "Species: <a href='byond://?src=\ref[src];species=input'>[species]</a><br>"
//	dat += "Secondary Language:<br><a href='byond://?src=\ref[src];language=input'>[language]</a><br>"
	dat += "Gender: <a href='byond://?src=\ref[src];gender=switch'>[gender == MALE ? "Male" : "Female"]</a><br>"
	if(gender == FEMALE && current_species.allow_slim_fem)
		dat += "Body build: <a href='byond://?src=\ref[src];build=switch'>[body_build == BODY_DEFAULT ? "Default" : "Slim"]</a><br>"

	if(current_species.flags & HAS_SKIN_TONE)
		dat += "Skin Tone: <a href='?src=\ref[src];skin_tone=input'>[skin_tone]/220<br></a>"

	dat += "<table style='border-collapse:collapse'>"
	dat += "<tr><td>Hair:</td><td><a href='byond://?src=\ref[src];hair=color'>Color "
	dat += "<span class='box' style='background-color:[hair_color];'></span></a>"
	dat += "Style: <a href='byond://?src=\ref[src];hair=style'>[h_style]</a></td></tr>"

	dat += "<tr><td>Facial:</td><td><a href='byond://?src=\ref[src];facial=color'>Color "
	dat += "<span class='box' style='background-color:[facial_color];'></span></a> "
	dat += " Style: <a href='byond://?src=\ref[src];facial=style'>[f_style]</a></td></tr>"

	dat += "<tr><td>Eyes:</td>"
	dat += "<td><a href='byond://?src=\ref[src];eyes=color'>Color "
	dat += "<span class='box' style='background-color:[eyes_color];'></span></a></td></tr>"

	if(current_species.flags & HAS_SKIN_COLOR)
		dat += "<tr><td>Skin color:</td>"
		dat += "<td><a href='byond://?src=\ref[src];skin=color'>Color "
		dat += "<span class='box' style='background-color:[skin_color];'></span></a></td></tr>"
	dat += "</table>"

	dat += "Age: <a href='byond://?src=\ref[src];age=input'>[age]</a><br>"
	dat += "Spawn Point: <a href='byond://?src=\ref[src];spawnpoint=input'>[spawnpoint]</a><br>"
	dat += "Corporate mail: <a href='byond://?src=\ref[src];mail=input'>[email ? email : "\[RANDOM MAIL\]"]</a>@mail.nt<br>"
	dat += "Add your mail to public catalogs: <a href='byond://?src=\ref[src];mail=public'>[email_is_public?"Yes":"No"]</a>"

	dat += "<br><br><b>Background Information</b><br>"
	dat += "Nanotrasen Relation: <a href ='?src=\ref[src];nt_relation=input'>[nanotrasen_relation]</a><br>"
	dat += "Home system: <a href='byond://?src=\ref[src];home_system=input'>[home_system]</a><br>"
	dat += "Citizenship: <a href='byond://?src=\ref[src];citizenship=input'>[citizenship]</a><br>"
	dat += "Faction: <a href='byond://?src=\ref[src];faction=input'>[faction]</a><br>"
	dat += "Religion: <a href='byond://?src=\ref[src];religion=input'>[religion]</a>"

	dat += "</td><td style='vertical-align:top'>"

	dat += "<b>Preview</b><br><img src=new_previewicon[preview_dir].png height=64 width=64>"
	dat += "<img src=new_previewicon[turn(preview_dir,-90)].png height=64 width=64><br>"

	dat += "<br><br><b>Set Character Records</b><br>"
	dat += "<a href='byond://?src=\ref[src];records=med'>Medical Records</a><br>"
	dat += "<span style='white-space: nowrap;'>[TextPreview(med_record,26)]</span>"
	dat += "<br><a href='byond://?src=\ref[src];records=gen'>Employment Records</a><br>"
	dat += "<span style='white-space: nowrap;'>[TextPreview(gen_record,26)]</span>"
	dat += "<br><a href='byond://?src=\ref[src];records=sec'>Security Records</a><br>"
	dat += "<span style='white-space: nowrap;'>[TextPreview(sec_record,26)]</span>"
	dat += "<br><a href='byond://?src=\ref[src];records=exp'>Exploitable Record</a><br>"
	dat += "<span style='white-space: nowrap;'>[TextPreview(exploit_record,26)]</span>"

	dat += "<br><br>"
	dat += "<table style='position:relative; left:-3px'><tr><td>Need Glasses?<br>Coughing?<br>Nervousness?<br>Paraplegia?</td><td>"
	dat += "<a href='byond://?src=\ref[src];disabilities=glasses'>[disabilities & NEARSIGHTED ? "Yes" : "No"]</a><br>"
	dat += "<a href='byond://?src=\ref[src];disabilities=coughing'>[disabilities & COUGHING ? "Yes" : "No"]</a><br>"
	dat += "<a href='byond://?src=\ref[src];disabilities=nervousness'>[disabilities & NERVOUS ? "Yes" : "No"]</a><br>"
	dat += "<a href='byond://?src=\ref[src];disabilities=paraplegia'>[disabilities & PARAPLEGIA ? "Yes" : "No"]</a>"
	dat += "</td></tr></table>"

	dat += "</td></tr></table>"

	return dat


/datum/preferences/proc/HandleRecordsTopic(mob/new_player/user, list/href_list)
	if(href_list["name"]) switch(href_list["name"])
		if("input")
			var/raw_name = input(user, "Choose your character's name:", "Character Preference")  as text|null
			if (!isnull(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
				var/new_name = sanitizeName(raw_name)
				if(new_name)
					real_name = new_name
				else
					user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"
		if("random")
			real_name = random_name(gender,species)
		if("random_always")
			random_name = !random_name

	else if(href_list["species"])
		var/choice = input("Which species would you like to look at?") as null|anything in playable_species
		if(!choice) return
		species_preview = choice
		spawn() SetSpecies(user)

	else if(href_list["gender"])
		if(gender == MALE)
			gender = FEMALE
		else
			gender = MALE
			body_build = 0

	else if(href_list["build"])
		if(body_build == BODY_DEFAULT && current_species.allow_slim_fem)
			body_build = BODY_SLIM
		else
			body_build = BODY_DEFAULT


	else if(href_list["hair"])
		switch(href_list["hair"])
			if("color")
				var/datum/sprite_accessory/H = hair_styles_list[h_style]
				if(H.do_colouration)
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", hair_color) as color|null
					if(new_hair)
						hair_color = new_hair
			if("style")
				var/list/valid_hairstyles = gender==MALE ? hair_styles_male_list : hair_styles_female_list
				for(var/hairstyle in hair_styles_list)
					var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
					if(!(species in S.species_allowed))
						valid_hairstyles -= hairstyle
				var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in valid_hairstyles
				if(new_h_style)
					h_style = new_h_style


	else if(href_list["facial"])
		switch(href_list["facial"])
			if("color")
				var/datum/sprite_accessory/F = facial_hair_styles_list[f_style]
				if(F.do_colouration)
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", facial_color) as color|null
					if(new_facial)
						facial_color = new_facial
			if("style")
				var/list/valid_facialhairstyles = gender==MALE ? facial_hair_styles_male_list : facial_hair_styles_female_list
				for(var/facialhairstyle in valid_facialhairstyles)
					var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
					if(!(species in S.species_allowed))
						valid_facialhairstyles -= facialhairstyle
				var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in valid_facialhairstyles
				if(new_f_style)
					f_style = new_f_style

	else if(href_list["eyes"])
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", eyes_color) as color|null
		if(new_eyes)
			eyes_color = new_eyes

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
		if(new_age)
			age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

	else if(href_list["skin_tone"])
		if(current_species.flags & HAS_SKIN_TONE)
			var/new_skin_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", skin_tone)  as num|null
			if(new_skin_tone)
				skin_tone = max(min( round(new_skin_tone), 255),1)

	else if(href_list["skin"])
		if(current_species.flags & HAS_SKIN_COLOR)
			var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", skin_color) as color|null
			if(new_skin)
				skin_color = new_skin

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/S in spawntypes)
			spawnkeys += S
		var/choice = input(user, "Where would you like to spawn when latejoining?") as null|anything in spawnkeys
		if(!choice || !spawntypes[choice])
			spawnpoint = "Arrivals Shuttle"
			return
		spawnpoint = choice


	else if(href_list["mail"]) switch(href_list["mail"])
		if("input")
			var/raw_email = input(user, "Choose your character's name:", "Character Preference")  as text|null
			if (!isnull(raw_email)) // Check to ensure that the user entered text (rather than cancel.)
				var/new_email = replacetext(reject_bad_text(raw_email), " ", "")
				if(!new_email)
					user << "<span class = 'warning'>Your mail will be generated when you enter round.</span>"
				email = new_email

		if("public")
			email_is_public = !email_is_public


	else if(href_list["nt_relation"])
		var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background,\
 not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
		if(new_relation)
			nanotrasen_relation = new_relation

	else if(href_list["home_system"])
		var/choice = input(user, "Please choose a home system.") as null|anything in home_system_choices + list("Unset","Other")
		if(!choice)
			return
		if(choice == "Other")
			var/raw_choice = input(user, "Please enter a home system.")  as text|null
			if(raw_choice)
				home_system = sanitize(raw_choice)
			return
		home_system = choice

	else if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.") as null|anything in citizenship_choices + list("None","Other")
		if(!choice)
			return
		if(choice == "Other")
			var/raw_choice = input(user, "Please enter your current citizenship.", "Character Preference") as text|null
			if(raw_choice)
				citizenship = sanitize(raw_choice)
			return
		citizenship = choice

	else if(href_list["faction"])
		var/choice = input(user, "Please choose a faction to work for.") as null|anything in faction_choices + list("None","Other")
		if(!choice)
			return
		if(choice == "Other")
			var/raw_choice = input(user, "Please enter a faction.")  as text|null
			if(raw_choice)
				faction = sanitize(raw_choice)
			return
		faction = choice

	else if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.") as null|anything in religion_choices + list("None","Other")
		if(!choice)
			return
		if(choice == "Other")
			var/raw_choice = input(user, "Please enter a religon.")  as text|null
			if(raw_choice)
				religion = sanitize(raw_choice)
			return
		religion = choice

	else if(href_list["records"]) switch(href_list["records"])
		if("med")
			var/medmsg = sanitize(input(usr,"Set your medical notes here.","Medical Records",rhtml_decode(edit_utf8(med_record))) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if(medmsg != null)
				med_record = cp1251_to_utf8(post_edit_utf8(medmsg))

		if("sec")
			var/secmsg = sanitize(input(usr,"Set your security notes here.","Security Records",rhtml_decode(edit_utf8(sec_record))) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if(secmsg != null)
				sec_record = cp1251_to_utf8(post_edit_utf8(secmsg))

		if("gen")
			var/genmsg = sanitize(input(usr,"Set your employment notes here.","Employment Records",rhtml_decode(edit_utf8(gen_record))) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if(genmsg != null)
				gen_record = cp1251_to_utf8(post_edit_utf8(genmsg))

		if("exp")
			var/expmsg = sanitize(input(usr,"Set exploitable information about you here.","Exploitable Information",rhtml_decode(edit_utf8(exploit_record))) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if(expmsg != null)
				exploit_record = cp1251_to_utf8(post_edit_utf8(expmsg))
	return

/datum/preferences/proc/GetLimbsPage()
	var/dat = "<style>div.block{border: 3px solid black;margin: 3px 0px;padding: 4px 0px;}</style>"
	dat += "<table style='max-height:400px;height:400px;'>"
	dat += "<tr style='vertical-align:top;'><td><div style='max-width:210px;width:210px;height:100%;overflow-y:auto;border:solid;padding:3px'>"
	dat += modifications_list[current_organ]
	dat += "</div></td><td style='margin-left:10px;width-max:285px;width:285px;border:solid'>"
	dat += "<table><tr><td style='width:95px; text-align:right'>"

	for(var/organ in r_organs)
		var/datum/body_modification/mod = get_modification(modifications_data[organ])
		var/disp_name = mod ? mod.short_name : "Nothing"
		if(organ == current_organ)
			dat += "<div><b><u>[r_organs[organ]]</u></b>"
		else
			dat += "<div><b>[r_organs[organ]]</b>"
		dat += "<br><a href='byond://?src=\ref[src];organ=[organ]'>[disp_name]</a></div>"

	dat += "</td><td style='width:80px;text-align:center'><img src=new_previewicon[preview_dir].png height=64 width=64></td>"
	dat += "<td style='width:95px'>"

	for(var/organ in l_organs)
		var/datum/body_modification/mod = get_modification(modifications_data[organ])
		var/disp_name = mod ? mod.short_name : "Nothing"
		if(organ == current_organ)
			dat += "<div><b><u>[l_organs[organ]]</u></b>"
		else
			dat += "<div><b>[l_organs[organ]]</b>"
		dat += "<br><a href='byond://?src=\ref[src];organ=[organ]'>[disp_name]</a></div>"

	dat += "</td></tr></table><hr>"

	dat += "<table cellpadding='1' cellspacing='0' width='100%'>"
	dat += "<tr align='center'>"
	var/counter = 0
	for(var/organ in internal_organs)
		if(!organ in body_modifications) continue

		var/datum/body_modification/mod = get_modification(modifications_data[organ])
		var/disp_name = mod.short_name
		if(organ == current_organ)
			dat += "<td width='33%'><b><u>[internal_organs[organ]]</u></b>"
		else
			dat += "<td width='33%'><b>[internal_organs[organ]]</b>"
		dat += "<br><a href='byond://?src=\ref[src];organ=[organ]'>[disp_name]</a></td>"

		if(++counter >= 3) //So things dont get squiiiiished!
			dat += "</tr><tr align='center'>"
			counter = 0
	dat += "</tr></table>"

	dat += "</span></div>"

	return dat

/datum/preferences/proc/get_modification(var/organ as text)
	if(!organ) return body_modifications["nothing"]
	return body_modifications[modifications_data[organ] ? modifications_data[organ] : "nothing"]

/datum/preferences/proc/HandleLimbsTopic(mob/new_player/user, list/href_list)
	if(href_list["organ"])
		current_organ = href_list["organ"]

	if(href_list["body_modification"])
		var/datum/body_modification/mod = body_modifications[href_list["body_modification"]]
		if(mod && mod.is_allowed(src))
			modifications_data[current_organ] = mod.id
			if(current_organ in parents_list)
				var/datum/body_modification/parent_mod = get_modification(parents_list[current_organ])
				if(parent_mod.nature > mod.nature)
					modifications_data[parents_list[current_organ]] = get_default_modificaton(mod.nature)
			else if(current_organ in children_list)
				var/datum/body_modification/child_mod = get_modification(children_list[current_organ])
				if(child_mod.nature < mod.nature)
					modifications_data[children_list[current_organ]] = get_default_modificaton(mod.nature)


/datum/preferences/proc/GetLoadOutPage()



/datum/preferences/proc/GetOccupationPage()

/datum/preferences/proc/GetSiliconPage()

/datum/preferences/proc/GetPrefsPage()


/datum/preferences/proc/HandleLoadOutTopic(mob/new_player/user, list/href_list)
/datum/preferences/proc/HandleOccupationTopic(mob/new_player/user, list/href_list)
/datum/preferences/proc/HandleSiliconTopic(mob/new_player/user, list/href_list)
/datum/preferences/proc/HandlePrefsTopic(mob/new_player/user, list/href_list)


#undef PAGE_RECORDS
#undef PAGE_LIMBS
#undef PAGE_OCCUPATION
#undef PAGE_LOADOUT
#undef PAGE_SILICON
#undef PAGE_PREFS