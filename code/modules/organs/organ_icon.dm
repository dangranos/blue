/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.mob_icon
		overlays += organ.mob_icon

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	s_tone = null
	s_col = null
	if(robotic >= ORGAN_ROBOT)
		return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_SKIN_TONE))
		s_tone = human.s_tone
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		s_col = human.skin_color

/obj/item/organ/external/proc/sync_colour_to_dna()
	s_tone = null
	s_col = null
	if(robotic >= ORGAN_ROBOT)
		return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_SKIN_TONE))
		s_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		s_col = rgb(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[O_EYES]
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head
	var/icon/hair
	var/icon/facial

/obj/item/organ/external/head/removed(user, delete_children)
	get_icon()
	if(hair)   mob_icon.Blend(hair, ICON_OVERLAY)
	if(facial) mob_icon.Blend(facial, ICON_OVERLAY)
	icon = mob_icon
	..()

/obj/item/organ/external/head/get_icon()

	..()
	overlays.Cut()
	if(!owner || !owner.species || !owner.body_build)
		return
	if(owner.should_have_organ(O_EYES))
		var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[O_EYES]
		if(eyes && eyes.mob_icon)
			mob_icon.Blend(eyes.mob_icon, ICON_OVERLAY)
			overlays |= eyes.mob_icon

	if(owner.lip_color && owner.species.appearance_flags & HAS_LIPS)
		var/icon/lip_icon = new/icon(owner.species.get_icobase(owner), "lips[owner.body_build.index]")
		lip_icon.Blend(owner.lip_color, ICON_ADD)
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype(owner) in facial_hair_style.species_allowed))
			var/icon/facial = new/icon(facial_hair_style.icon, facial_hair_style.icon_state)
			if(facial_hair_style.do_colouration)
				facial.Blend(owner.facial_color, ICON_ADD)
			overlays |= facial

	if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
		if(hair_style && (species.get_bodytype(owner) in hair_style.species_allowed))
			var/icon/hair = new/icon(hair_style.icon, hair_style.icon_state)
			if(hair_style.do_colouration && owner.hair_color)
				hair.Blend(owner.hair_color, ICON_ADD)
			overlays |= hair

	icon = mob_icon
	return mob_icon

/obj/item/organ/external/proc/get_icon_key()
	if(robotic >= ORGAN_ROBOT)
		. = "2[model ? "-[model]": ""]"
	else if(status & ORGAN_MUTATED)
		. = "3"
	else if(status & ORGAN_DEAD)
		. = "4"
	else
		. = "1"

	. += "[species.get_race_key(owner)][dna.GetUIState(DNA_UI_GENDER)][dna.GetUIValue(DNA_UI_SKIN_TONE)]"
	if(s_col)
		. += s_col

/obj/item/organ/external/proc/get_icon(var/skeletal)

	var/gender = "_f"
	var/body_build = ""
	if(owner)
		if(owner.gender == MALE)
			gender = "_m"
		body_build = owner.body_build.index

	icon_state = "[organ_tag][gendered_icon ? gender : ""][body_build]"
	icon_cache_key = "[organ_tag][species ? species.name : "Human"]"

	if(force_icon)
		mob_icon = new /icon(force_icon, icon_state)
	else
		if(!dna)
			mob_icon = new /icon('icons/mob/human_races/r_human.dmi', icon_state)
		else

			if(!gendered_icon)
				gender = null
			else
				if(dna.GetUIState(DNA_UI_GENDER))
					gender = "f"
				else
					gender = "m"

			if(skeletal)
				mob_icon = new /icon('icons/mob/human_races/r_skeleton.dmi', icon_state)
			else if (robotic >= ORGAN_ROBOT)
				mob_icon = new /icon('icons/mob/human_races/robotic.dmi', icon_state)
			else
				if(is_stump()) icon_state+="_s"
				mob_icon = new /icon(owner.species.icobase, icon_state)
				apply_colouration(mob_icon)

	if(model)
		icon_cache_key += "_model_[model]"

	dir = EAST
	icon = mob_icon
	return mob_icon

/obj/item/organ/external/proc/apply_colouration(var/icon/applying)

	if(nonsolid)
		applying.MapColors("#4D4D4D","#969696","#1C1C1C", "#000000")
		if(species && species.get_bodytype(owner) != "Human")
			applying.SetIntensity(1.5) // Unathi, Taj and Skrell have -very- dark base icons.
		else
			applying.SetIntensity(0.7)

	else if(status & ORGAN_DEAD)
		icon_cache_key += "_dead"
		applying.ColorTone(rgb(10,50,0))
		applying.SetIntensity(0.7)

	if(!isnull(s_tone))
		if(s_tone >= 0)
			applying.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
		else
			applying.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
		icon_cache_key += "_tone_[s_tone]"
	else if(s_col)
		applying.Blend(s_col, ICON_ADD)
		icon_cache_key += "_color_[s_col]"

	// Translucency.
	if(nonsolid) applying += rgb(,,,180) // SO INTUITIVE TY BYOND

	return applying

/obj/item/organ/external/var/icon_cache_key

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0


// Returns an image for use by the human health dolly HUD element.
// If the user has traumatic shock, it will be passed in as a minimum
// damage amount to represent the pain of the injuries involved.

// Global scope, used in code below.
var/list/flesh_hud_colours = list("#02BA08","#9ECF19","#DEDE10","#FFAA00","#FF0000","#AA0000","#660000")
var/list/robot_hud_colours = list("#CFCFCF","#AFAFAF","#8F8F8F","#6F6F6F","#4F4F4F","#2F2F2F","#000000")

/obj/item/organ/external/proc/get_damage_hud_image(var/min_dam_state)

	// Generate the greyscale base icon and cache it for later.
	// icon_cache_key is set by any get_icon() calls that are made.
	// This looks convoluted, but it's this way to avoid icon proc calls.
	if(!hud_damage_image)
		var/cache_key = "dambase-[icon_cache_key]"
		if(!icon_cache_key || !limb_icon_cache[cache_key])
			limb_icon_cache[cache_key] = icon(get_icon(), null, SOUTH)
		var/image/temp = image(limb_icon_cache[cache_key])
		if((robotic < ORGAN_ROBOT) && species)
			// Calculate the required colour matrix.
			var/r = 0.30 * species.health_hud_intensity
			var/g = 0.59 * species.health_hud_intensity
			var/b = 0.11 * species.health_hud_intensity
			temp.color = list(r, r, r, g, g, g, b, b, b)
		else if(model)
			var/datum/robolimb/R = all_robolimbs[model]
			if(istype(R))
				var/r = 0.30 * R.health_hud_intensity
				var/g = 0.59 * R.health_hud_intensity
				var/b = 0.11 * R.health_hud_intensity
				temp.color = list(r, r, r, g, g, g, b, b, b)
		hud_damage_image = image(null)
		hud_damage_image.overlays += temp

	// Calculate the required color index.
	var/dam_state = min(1,((brute_dam+burn_dam)/max_damage))
	// Apply traumatic shock min damage state.
	if(!isnull(min_dam_state) && dam_state < min_dam_state)
		dam_state = min_dam_state
	// Apply colour and return product.
	var/list/hud_colours = (robotic < ORGAN_ROBOT) ? flesh_hud_colours : robot_hud_colours
	hud_damage_image.color = hud_colours[max(1,min(ceil(dam_state*hud_colours.len),hud_colours.len))]
	return hud_damage_image
