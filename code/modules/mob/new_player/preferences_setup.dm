datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/randomize_appearance_for(var/mob/living/carbon/human/H)
		if(H)
			if(H.gender == MALE)
				gender = MALE
			else
				gender = FEMALE
		s_tone = random_skin_tone()
		h_style = random_hair_style(gender, species)
		f_style = random_facial_hair_style(gender, species)
		randomize_hair_color("hair")
		randomize_hair_color("facial")
		randomize_eyes_color()
		randomize_mech_eyes_color()
		randomize_skin_color()
		underwear = rand(1,underwear_m.len)
		undershirt = rand(1,undershirt_t.len)
		backbag = 2
		age = rand(AGE_MIN,AGE_MAX)
		if(H)
			copy_to(H,1)

	proc/get_random_color()

		var/list/color_pack = list ("red" = 0, "blue" = 0, "green" = 0)

		var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
		switch(col)
			if("blonde")
				color_pack["red"] = 255
				color_pack["green"] = 255
				color_pack["blue"] = 0
			if("black")
				color_pack["red"] = 0
				color_pack["green"] = 0
				color_pack["blue"] = 0
			if("chestnut")
				color_pack["red"] = 153
				color_pack["green"] = 102
				color_pack["blue"] = 51
			if("copper")
				color_pack["red"] = 255
				color_pack["green"] = 153
				color_pack["blue"] = 0
			if("brown")
				color_pack["red"] = 102
				color_pack["green"] = 51
				color_pack["blue"] = 0
			if("wheat")
				color_pack["red"] = 255
				color_pack["green"] = 255
				color_pack["blue"] = 153
			if("old")
				color_pack["red"] = rand (100, 255)
				color_pack["green"] = color_pack["red"]
				color_pack["blue"] = color_pack["red"]
			if("punk")
				color_pack["red"] = rand (0, 255)
				color_pack["green"] = rand (0, 255)
				color_pack["blue"] = rand (0, 255)

		color_pack["red"] = max(min(color_pack["red"] + rand (-25, 25), 255), 0)
		color_pack["green"] = max(min(color_pack["green"] + rand (-25, 25), 255), 0)
		color_pack["blue"] = max(min(color_pack["blue"] + rand (-25, 25), 255), 0)

		return color_pack

	proc/randomize_hair_color(var/target = "hair")
		if(prob (75) && target == "facial") // Chance to inherit hair color
			facial_r = hair_r
			facial_g = hair_g
			facial_b = hair_b
			return

		var/colors = get_random_color()

		switch(target)
			if("hair")
				hair_r = colors["red"]
				hair_g = colors["green"]
				hair_b = colors["blue"]
			if("facial")
				facial_r = colors["red"]
				facial_g = colors["green"]
				facial_b = colors["blue"]

	proc/randomize_eyes_color()
		var/colors = get_random_color()

		eyes_r = colors["red"]
		eyes_g = colors["green"]
		eyes_b = colors["blue"]

	proc/randomize_mech_eyes_color()
		var/colors = get_random_color()

		mech_eyes_r = colors["red"]
		mech_eyes_g = colors["green"]
		mech_eyes_b = colors["blue"]

	proc/randomize_skin_color()
		var/colors = get_random_color()

		skin_r = colors["red"]
		skin_g = colors["green"]
		skin_b = colors["blue"]

	proc/update_preview_icon()		//seriously. This is horrendous.
		qdel(preview_icon_front)
		qdel(preview_icon_side)
		qdel(preview_icon)

		var/g = "m"
		if(gender == FEMALE)
			g = "f"
		var/b="[body_build]"
		g+=b

		var/icon/icobase
		var/datum/species/current_species = all_species[species]

		if(current_species)
			icobase = current_species.icobase
		else
			icobase = 'icons/mob/human_races/r_human.dmi'

		preview_icon = new /icon('icons/mob/human.dmi', "blank")
//		preview_icon.Blend(new /icon(icobase, "groin_[g]"), ICON_OVERLAY)
//		preview_icon.Blend(new /icon(icobase, "head_[g]"), ICON_OVERLAY)

		for(var/name in list("chest","groin","head","r_arm","r_hand","r_leg","r_foot","l_leg","l_foot","l_arm","l_hand"))
			if(organ_data[name] == "amputated") continue
			if(organ_data[name] == "cyborg")
				var/datum/robolimb/R
				if(rlimb_data[name]) R = all_robolimbs[rlimb_data[name]]
				if(!R) R = basic_robolimb
				preview_icon.Blend(icon(R.icon, "[name]_[g]"), ICON_OVERLAY) // This doesn't check gendered_icon. Not an issue while only limbs can be robotic.
				continue
			preview_icon.Blend(new /icon(icobase, "[name]_[g]"), ICON_OVERLAY)
			var/tattoo = tattoo_data[name]
			var/tattoo2 = tattoo_data["[name]2"]
			if(tattoo)  preview_icon.Blend(new/icon('icons/mob/tattoo.dmi', "[name]_[tattoo]_[b]"), ICON_OVERLAY)
			if(tattoo2) preview_icon.Blend(new/icon('icons/mob/tattoo.dmi', "[name]2_[tattoo2]_[b]"), ICON_OVERLAY)

		//Tail
		if(current_species && (current_species.tail))
			var/icon/temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[current_species.tail]_s")
			preview_icon.Blend(temp, ICON_OVERLAY)

		// Skin color
		if(current_species && (current_species.flags & HAS_SKIN_COLOR))
			preview_icon.Blend(rgb(skin_r, skin_g, skin_b), ICON_ADD)

		// Skin tone
		if(current_species && (current_species.flags & HAS_SKIN_TONE))
			if (s_tone >= 0)
				preview_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
			else
				preview_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)

		// Eyes color
		var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = current_species ? "[current_species.eyes][body_build]" : "eyes0")
		if ((current_species && (current_species.flags & HAS_EYE_COLOR)))
			if( organ_data["eyes"] == "mechanical" )
				eyes_s.Blend(rgb(mech_eyes_r, mech_eyes_g, mech_eyes_b), ICON_ADD)
			else
				eyes_s.Blend(rgb(eyes_r, eyes_g, eyes_b), ICON_ADD)

		// Hair Style'n'Color
		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style)
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			hair_s.Blend(rgb(hair_r, hair_g, hair_b), ICON_ADD)
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial_s.Blend(rgb(facial_r, facial_g, facial_b), ICON_ADD)
			eyes_s.Blend(facial_s, ICON_OVERLAY)

		var/icon/underwear_s = null
		if(underwear && current_species.flags & HAS_UNDERWEAR)
			underwear_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[underwear]_[g]")

		var/icon/undershirt_s = null
		if(undershirt && current_species.flags & HAS_UNDERWEAR)
			undershirt_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[undershirt]_[g]")

		var/icon/clothes_s = null
		if(job_civilian_low & ASSISTANT || !job_master)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
			clothes_s = new /icon(current_species.get_uniform_sprite("grey", body_build), "grey")
			clothes_s.Blend(new /icon(current_species.get_shoes_sprite("black", body_build), "black"), ICON_UNDERLAY)
			if(backbag == 2)
				clothes_s.Blend(new /icon(current_species.get_uniform_sprite("backpack", body_build), "backpack"), ICON_OVERLAY)
			else if(backbag == 3 || backbag == 4)
				clothes_s.Blend(new /icon(current_species.get_shoes_sprite("satchel", body_build), "satchel"), ICON_OVERLAY)

		else
			var/datum/job/J = job_master.GetJob(high_job_title)
			if(J)//I hate how this looks, but there's no reason to go through this switch if it's empty

				var/obj/item/clothing/under/UF = J.uniform
				clothes_s = new /icon(current_species.get_uniform_sprite(initial(UF.icon_state), body_build), initial(UF.icon_state))

				var/obj/item/clothing/shoes/SH = J.shoes
				clothes_s.Blend(new /icon(current_species.get_shoes_sprite(initial(SH.icon_state), body_build), initial(SH.icon_state)), ICON_UNDERLAY)

				var/obj/item/clothing/gloves/GL = J.gloves
				if(GL) clothes_s.Blend(new /icon(current_species.get_gloves_sprite(initial(GL.icon_state), body_build), initial(GL.icon_state)), ICON_UNDERLAY)

				var/obj/item/weapon/storage/belt/BT = J.belt
				if(BT) clothes_s.Blend(new /icon(current_species.get_belt_sprite(initial(BT.icon_state), body_build), initial(BT.icon_state)), ICON_OVERLAY)

				var/obj/item/clothing/suit/ST = J.suit
				if(ST) clothes_s.Blend(new /icon(current_species.get_suit_sprite(initial(ST.icon_state), body_build), initial(ST.icon_state)), ICON_OVERLAY)

				var/obj/item/clothing/head/HT = J.hat
				if(HT) clothes_s.Blend(new /icon(current_species.get_head_sprite(initial(HT.icon_state), body_build), initial(HT.icon_state)), ICON_OVERLAY)

				if( backbag > 1 )
					var/obj/item/weapon/storage/backpack/BP = J.backpacks[backbag-1]
					clothes_s.Blend(new /icon(current_species.get_back_sprite(initial(BP.icon_state), body_build), initial(BP.icon_state)), ICON_OVERLAY)

		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon((g == "f1")?'icons/mob/eyes_f.dmi':'icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)

		preview_icon.Blend(eyes_s, ICON_OVERLAY)
		if(underwear_s)
			preview_icon.Blend(underwear_s, ICON_OVERLAY)
		if(undershirt_s)
			preview_icon.Blend(undershirt_s, ICON_OVERLAY)
		if(clothes_s)
			preview_icon.Blend(clothes_s, ICON_OVERLAY)
		preview_icon_front = new(preview_icon, dir = SOUTH)
		preview_icon_side = new(preview_icon, dir = WEST)

		qdel(eyes_s)
		qdel(underwear_s)
		qdel(undershirt_s)
		qdel(clothes_s)
