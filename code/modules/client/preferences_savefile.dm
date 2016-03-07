#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	12

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefile_update()
	if(savefile_version < 8)	//lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in preferences_datums)
			var/datum/preferences/D = preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return 0

	if(savefile_version == SAVEFILE_VERSION_MAX)	//update successful.
		save_preferences()
		save_character()
		return 1
	return 0

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] >> savefile_version
	//Conversion
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update())  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return 0

	//general preferences
	S["ooccolor"]			>> ooccolor
	S["lastchangelog"]		>> lastchangelog
	S["UI_style"]			>> UI_style
	S["be_special"]			>> be_special
	S["default_slot"]		>> default_slot
	S["toggles"]			>> toggles
	S["UI_style_color"]		>> UI_style_color
	S["UI_style_alpha"]		>> UI_style_alpha

	//Sanitize
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("White", "Midnight","Orange","old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))

	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] << savefile_version

	//general preferences
	S["ooccolor"]			<< ooccolor
	S["lastchangelog"]		<< lastchangelog
	S["UI_style"]			<< UI_style
	S["be_special"]			<< be_special
	S["default_slot"]		<< default_slot
	S["toggles"]			<< toggles

	return 1

/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot
	slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		S["default_slot"] << slot
	S.cd = "/character[slot]"

	//Character
	S["real_name"]			>> real_name
	S["name_is_always_random"] >> random_name
	S["gender"]				>> gender
	S["body_build"]			>> body_build
	S["age"]				>> age
	S["species"]			>> species
	current_species = all_species[species]
	if(!current_species)
		current_species = all_species["Human"]
	S["language"]			>> language
	S["spawnpoint"]			>> spawnpoint

	//colors to be consolidated into hex strings (requires some work with dna code)
	S["hair_red"]			>> hair_r
	S["hair_green"]			>> hair_g
	S["hair_blue"]			>> hair_b
	S["facial_red"]			>> facial_r
	S["facial_green"]		>> facial_g
	S["facial_blue"]		>> facial_b
	S["skin_tone"]			>> s_tone
	S["skin_red"]			>> skin_r
	S["skin_green"]			>> skin_g
	S["skin_blue"]			>> skin_b
	S["hair_style_name"]	>> h_style
	S["facial_style_name"]	>> f_style
	S["eyes_red"]			>> eyes_r
	S["eyes_green"]			>> eyes_g
	S["eyes_blue"]			>> eyes_b
	S["mech_eyes_red"]		>> mech_eyes_r
	S["mech_eyes_green"]	>> mech_eyes_g
	S["mech_eyes_blue"]		>> mech_eyes_b
	S["underwear"]			>> underwear
	S["undershirt"]			>> undershirt
	S["backbag"]			>> backbag
	S["b_type"]				>> b_type

	//Jobs
	S["alternate_option"]	>> alternate_option
	S["high_job_title"]		>> high_job_title
	S["job_civilian_high"]	>> job_civilian_high
	S["job_civilian_med"]	>> job_civilian_med
	S["job_civilian_low"]	>> job_civilian_low
	S["job_medsci_high"]	>> job_medsci_high
	S["job_medsci_med"]		>> job_medsci_med
	S["job_medsci_low"]		>> job_medsci_low
	S["job_engsec_high"]	>> job_engsec_high
	S["job_engsec_med"]		>> job_engsec_med
	S["job_engsec_low"]		>> job_engsec_low

	//Flavour Text
	for(var/flavor in flavs_list)
		S["flavor_texts_[flavor]"]	>> flavor_texts[flavor]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] >> flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] >> flavour_texts_robot[module]

	//Miscellaneous
	S["med_record"]			>> med_record
	S["sec_record"]			>> sec_record
	S["gen_record"]			>> gen_record
	S["be_special"]			>> be_special
	S["disabilities"]		>> disabilities
	S["player_alt_titles"]	>> player_alt_titles
	S["organ_data"]			>> organ_data
	S["rlimb_data"]			>> rlimb_data
	S["tattoo_data"]		>> tattoo_data
	S["gear"]				>> gear
	S["home_system"] 		>> home_system
	S["citizenship"] 		>> citizenship
	S["faction"] 			>> faction
	S["religion"] 			>> religion

	S["nanotrasen_relation"] >> nanotrasen_relation
	//S["skin_style"]			>> skin_style

	S["uplinklocation"] >> uplinklocation
	S["exploit_record"]	>> exploit_record

	S["UI_style_color"]		<< UI_style_color
	S["UI_style_alpha"]		<< UI_style_alpha

	//Sanitize
	real_name		= sanitizeName(real_name)

	if(isnull(species) || !(species in playable_species))
		species = "Human"

	if(isnum(underwear))
		var/list/undies = gender == MALE ? underwear_m : underwear_f
		underwear = undies[undies[underwear]]

	if(isnum(undershirt))
		undershirt = undershirt_t[undershirt_t[undershirt]]

	if(isnull(language)) language = "None"
	if(isnull(spawnpoint)) spawnpoint = "Arrivals Shuttle"
	if(isnull(nanotrasen_relation)) nanotrasen_relation = initial(nanotrasen_relation)
	if(!real_name) real_name = random_name(gender)
	random_name		= sanitize_integer(random_name, 0, 1, initial(random_name))
	gender			= sanitize_gender(gender)
	body_build 		= sanitize_integer(body_build, 0, 1, initial(body_build))
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	hair_r			= sanitize_integer(hair_r, 0, 255, initial(hair_r))
	hair_g			= sanitize_integer(hair_g, 0, 255, initial(hair_g))
	hair_b			= sanitize_integer(hair_b, 0, 255, initial(hair_b))
	facial_r		= sanitize_integer(facial_r, 0, 255, initial(facial_r))
	facial_g		= sanitize_integer(facial_g, 0, 255, initial(facial_g))
	facial_b		= sanitize_integer(facial_b, 0, 255, initial(facial_b))
	s_tone			= sanitize_integer(s_tone, -185, 34, initial(s_tone))
	skin_r			= sanitize_integer(skin_r, 0, 255, initial(skin_r))
	skin_g			= sanitize_integer(skin_g, 0, 255, initial(skin_g))
	skin_b			= sanitize_integer(skin_b, 0, 255, initial(skin_b))
	h_style			= sanitize_inlist(h_style, hair_styles_list, initial(h_style))
	f_style			= sanitize_inlist(f_style, facial_hair_styles_list, initial(f_style))
	eyes_r			= sanitize_integer(eyes_r, 0, 255, initial(eyes_r))
	eyes_g			= sanitize_integer(eyes_g, 0, 255, initial(eyes_g))
	eyes_b			= sanitize_integer(eyes_b, 0, 255, initial(eyes_b))
	mech_eyes_r		= sanitize_integer(mech_eyes_r, 0, 255, initial(mech_eyes_r))
	mech_eyes_g		= sanitize_integer(mech_eyes_g, 0, 255, initial(mech_eyes_g))
	mech_eyes_b		= sanitize_integer(mech_eyes_b, 0, 255, initial(mech_eyes_b))
	backbag			= sanitize_integer(backbag, 1, backbaglist.len, initial(backbag))
	b_type			= sanitize_text(b_type, initial(b_type))

	alternate_option = sanitize_integer(alternate_option, 0, 2, initial(alternate_option))
	job_civilian_high = sanitize_integer(job_civilian_high, 0, 65535, initial(job_civilian_high))
	job_civilian_med = sanitize_integer(job_civilian_med, 0, 65535, initial(job_civilian_med))
	job_civilian_low = sanitize_integer(job_civilian_low, 0, 65535, initial(job_civilian_low))
	job_medsci_high = sanitize_integer(job_medsci_high, 0, 65535, initial(job_medsci_high))
	job_medsci_med = sanitize_integer(job_medsci_med, 0, 65535, initial(job_medsci_med))
	job_medsci_low = sanitize_integer(job_medsci_low, 0, 65535, initial(job_medsci_low))
	job_engsec_high = sanitize_integer(job_engsec_high, 0, 65535, initial(job_engsec_high))
	job_engsec_med = sanitize_integer(job_engsec_med, 0, 65535, initial(job_engsec_med))
	job_engsec_low = sanitize_integer(job_engsec_low, 0, 65535, initial(job_engsec_low))

	if(isnull(disabilities)) disabilities = 0
	if(!player_alt_titles) player_alt_titles = new()
	if(!organ_data) src.organ_data = list()
	if(!rlimb_data) src.rlimb_data = list()
	if(!tattoo_data) src.tattoo_data = list()
	if(!gear) src.gear = list()
	//if(!skin_style) skin_style = "Default"

	if(!home_system) home_system = "Unset"
	if(!citizenship) citizenship = "None"
	if(!faction)     faction =     "None"
	if(!religion)    religion =    "None"

	return 1

/datum/preferences/proc/save_character()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[default_slot]"

	//Character
	S["real_name"]			<< real_name
	S["name_is_always_random"] << random_name
	S["gender"]				<< gender
	S["body_build"]			<< body_build
	S["age"]				<< age
	S["species"]			<< species
	S["language"]			<< language
	S["hair_red"]			<< hair_r
	S["hair_green"]			<< hair_g
	S["hair_blue"]			<< hair_b
	S["facial_red"]			<< facial_r
	S["facial_green"]		<< facial_g
	S["facial_blue"]		<< facial_b
	S["skin_tone"]			<< s_tone
	S["skin_red"]			<< skin_r
	S["skin_green"]			<< skin_g
	S["skin_blue"]			<< skin_b
	S["hair_style_name"]	<< h_style
	S["facial_style_name"]	<< f_style
	S["eyes_red"]			<< eyes_r
	S["eyes_green"]			<< eyes_g
	S["eyes_blue"]			<< eyes_b
	S["mech_eyes_red"]		<< mech_eyes_r
	S["mech_eyes_green"]	<< mech_eyes_g
	S["mech_eyes_blue"]		<< mech_eyes_b
	S["underwear"]			<< underwear
	S["undershirt"]			<< undershirt
	S["backbag"]			<< backbag
	S["b_type"]				<< b_type
	S["spawnpoint"]			<< spawnpoint

	//Jobs
	S["alternate_option"]	<< alternate_option
	S["high_job_title"]		<< high_job_title
	S["job_civilian_high"]	<< job_civilian_high
	S["job_civilian_med"]	<< job_civilian_med
	S["job_civilian_low"]	<< job_civilian_low
	S["job_medsci_high"]	<< job_medsci_high
	S["job_medsci_med"]		<< job_medsci_med
	S["job_medsci_low"]		<< job_medsci_low
	S["job_engsec_high"]	<< job_engsec_high
	S["job_engsec_med"]		<< job_engsec_med
	S["job_engsec_low"]		<< job_engsec_low

	//Flavour Text
	for(var/flavor in flavs_list)
		S["flavor_texts_[flavor]"]	<< flavor_texts[flavor]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] << flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] << flavour_texts_robot[module]

	//Miscellaneous
	S["med_record"]			<< med_record
	S["sec_record"]			<< sec_record
	S["gen_record"]			<< gen_record
	S["player_alt_titles"]	<< player_alt_titles
	S["be_special"]			<< be_special
	S["disabilities"]		<< disabilities
	S["organ_data"]			<< organ_data
	S["rlimb_data"]			<< rlimb_data
	S["tattoo_data"]		<< tattoo_data
	S["gear"]				<< gear
	S["home_system"] 		<< home_system
	S["citizenship"] 		<< citizenship
	S["faction"] 			<< faction
	S["religion"] 			<< religion

	S["nanotrasen_relation"] << nanotrasen_relation
	//S["skin_style"]			<< skin_style

	S["uplinklocation"] << uplinklocation
	S["exploit_record"]	<< exploit_record

	S["UI_style_color"]		<< UI_style_color
	S["UI_style_alpha"]		<< UI_style_alpha

	return 1


#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN