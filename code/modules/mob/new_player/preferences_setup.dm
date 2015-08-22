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
		del(preview_icon_front)
		del(preview_icon_side)
		del(preview_icon)

		var/g = "m"
		if(gender == FEMALE)	g = "f"

		var/icon/icobase
		var/datum/species/current_species = all_species[species]

		if(current_species)
			icobase = current_species.icobase
		else
			icobase = 'icons/mob/human_races/r_human.dmi'

		preview_icon = new /icon(icobase, "torso_[g]")
		preview_icon.Blend(new /icon(icobase, "groin_[g]"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "head_[g]"), ICON_OVERLAY)

		for(var/name in list("r_arm","r_hand","r_leg","r_foot","l_leg","l_foot","l_arm","l_hand"))
			if(organ_data[name] == "amputated") continue

			var/icon/temp = new /icon(icobase, "[name]")
			if(organ_data[name] == "cyborg")
				temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))

			preview_icon.Blend(temp, ICON_OVERLAY)

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
		var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = current_species ? current_species.eyes : "eyes_s")
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
			underwear_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = underwear)

		var/icon/undershirt_s = null
		if(undershirt && current_species.flags & HAS_UNDERWEAR)
			undershirt_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = undershirt)

		var/icon/clothes_s = null
		if(job_civilian_low & ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
			clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
			if(backbag == 2)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
			else if(backbag == 3 || backbag == 4)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)


		else
			var/datum/job/J = job_master.GetJob(high_job_title)
			if(J)//I hate how this looks, but there's no reason to go through this switch if it's empty

				var/obj/item/clothing/under/UF = J.uniform
				clothes_s = new /icon('icons/mob/uniform.dmi', "[initial(UF.item_color)]_s")

				var/obj/item/clothing/shoes/SH = J.shoes
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', initial(SH.item_state)), ICON_UNDERLAY)

				var/obj/item/clothing/gloves/GL = J.gloves
				if(GL) clothes_s.Blend(new /icon('icons/mob/hands.dmi', initial(GL.item_state)), ICON_UNDERLAY)

				var/obj/item/weapon/storage/belt/BT = J.belt
				if(BT) clothes_s.Blend(new /icon('icons/mob/belt.dmi', initial(BT.item_state)), ICON_OVERLAY)

				var/obj/item/clothing/suit/ST = J.suit
				if(ST) clothes_s.Blend(new /icon('icons/mob/suit.dmi', initial(ST.item_state)), ICON_OVERLAY)

				var/obj/item/clothing/head/HT = J.hat
				if(HT) clothes_s.Blend(new /icon('icons/mob/head.dmi', initial(HT.item_state)), ICON_OVERLAY)

				if( backbag > 1 )
					var/obj/item/weapon/storage/backpack/BP = J.backpacks[backbag-1]
					clothes_s.Blend(new /icon('icons/mob/back.dmi', initial(BP.item_state)), ICON_OVERLAY)

		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon('icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)

		preview_icon.Blend(eyes_s, ICON_OVERLAY)
		if(underwear_s)
			preview_icon.Blend(underwear_s, ICON_OVERLAY)
		if(undershirt_s)
			preview_icon.Blend(undershirt_s, ICON_OVERLAY)
		if(clothes_s)
			preview_icon.Blend(clothes_s, ICON_OVERLAY)
		preview_icon_front = new(preview_icon, dir = SOUTH)
		preview_icon_side = new(preview_icon, dir = WEST)

		del(eyes_s)
		del(underwear_s)
		del(undershirt_s)
		del(clothes_s)
