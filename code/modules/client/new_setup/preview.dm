datum/preferences
	var/icon/preview_south = null
	var/icon/preview_north = null
	var/icon/preview_east  = null
	var/icon/preview_west  = null
	var/preview_dir = SOUTH
	proc/new_update_preview_icon()
		for(var/dir in cardinal)
			qdel(preview_south)
			qdel(preview_north)
			qdel(preview_east)
			qdel(preview_west)
		qdel(preview_icon)

		var/g = "m"
		if(gender == FEMALE)
			g = "f"
		var/b="[body_build]"
		g+=b

		var/icon/icobase = current_species.icobase

		preview_icon = new /icon('icons/mob/human.dmi', "blank")

		for(var/organ in list("chest","groin","head","r_arm","r_hand","r_leg","r_foot","l_leg","l_foot","l_arm","l_hand"))
			var/datum/body_modification/mod = get_modification(organ)
			if(!mod.replace_limb)
				preview_icon.Blend(new /icon(icobase, "[organ]_[g]"), ICON_OVERLAY)
			preview_icon.Blend(mod.get_mob_icon(organ, body_build), ICON_OVERLAY)

		//Tail
		if(current_species && (current_species.tail))
			var/icon/temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[current_species.tail]_s")
			preview_icon.Blend(temp, ICON_OVERLAY)

		// Skin color
		if(current_species && (current_species.flags & HAS_SKIN_COLOR))
			preview_icon.Blend(skin_color, ICON_ADD)

		// Skin tone
		if(current_species && (current_species.flags & HAS_SKIN_TONE))
			if (s_tone >= 0)
				preview_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
			else
				preview_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)

		// Eyes color
		var/icon/eyes = new/icon("icon" = icobase, "icon_state" = "eyes_[body_build]")
		if ((current_species && (current_species.flags & HAS_EYE_COLOR)))
			eyes.Blend(eyes_color, ICON_ADD)

		// Hair Style'n'Color
		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			hair.Blend(hair_color, ICON_ADD)
			eyes.Blend(hair, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial.Blend(facial_color, ICON_ADD)
			eyes.Blend(facial, ICON_OVERLAY)

		var/icon/underwear = null
		if(underwear && current_species.flags & HAS_UNDERWEAR)
			underwear = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[underwear]_[g]")

		var/icon/undershirt = null
		if(undershirt && current_species.flags & HAS_UNDERWEAR)
			undershirt = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[undershirt]_[g]")

		var/icon/clothes = null
		if(job_civilian_low & ASSISTANT || !job_master)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
			clothes = new /icon(current_species.get_uniform_sprite("grey", body_build), "grey")
			clothes.Blend(new /icon(current_species.get_shoes_sprite("black", body_build), "black"), ICON_UNDERLAY)
			if(backbag == 2)
				clothes.Blend(new /icon(current_species.get_uniform_sprite("backpack", body_build), "backpack"), ICON_OVERLAY)
			else if(backbag == 3 || backbag == 4)
				clothes.Blend(new /icon(current_species.get_shoes_sprite("satchel", body_build), "satchel"), ICON_OVERLAY)

		else
			var/datum/job/J = job_master.GetJob(high_job_title)
			if(J)

				var/obj/item/clothing/under/UF = J.uniform
				clothes = new /icon(current_species.get_uniform_sprite(initial(UF.icon_state), body_build), initial(UF.icon_state))

				var/obj/item/clothing/shoes/SH = J.shoes
				clothes.Blend(new /icon(current_species.get_shoes_sprite(initial(SH.icon_state), body_build), initial(SH.icon_state)), ICON_UNDERLAY)

				var/obj/item/clothing/gloves/GL = J.gloves
				if(GL) clothes.Blend(new /icon(current_species.get_gloves_sprite(initial(GL.icon_state), body_build), initial(GL.icon_state)), ICON_UNDERLAY)

				var/obj/item/weapon/storage/belt/BT = J.belt
				if(BT) clothes.Blend(new /icon(current_species.get_belt_sprite(initial(BT.icon_state), body_build), initial(BT.icon_state)), ICON_OVERLAY)

				var/obj/item/clothing/suit/ST = J.suit
				if(ST) clothes.Blend(new /icon(current_species.get_suit_sprite(initial(ST.icon_state), body_build), initial(ST.icon_state)), ICON_OVERLAY)

				var/obj/item/clothing/head/HT = J.hat
				if(HT) clothes.Blend(new /icon(current_species.get_head_sprite(initial(HT.icon_state), body_build), initial(HT.icon_state)), ICON_OVERLAY)

				if( backbag > 1 )
					var/obj/item/weapon/storage/backpack/BP = J.backpacks[backbag-1]
					clothes.Blend(new /icon(current_species.get_back_sprite(initial(BP.icon_state), body_build), initial(BP.icon_state)), ICON_OVERLAY)

		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon((g == "f1")?'icons/mob/eyes_f.dmi':'icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)

		preview_icon.Blend(eyes, ICON_OVERLAY)
		if(underwear)
			preview_icon.Blend(underwear, ICON_OVERLAY)
		if(undershirt)
			preview_icon.Blend(undershirt, ICON_OVERLAY)
		if(clothes)
			preview_icon.Blend(clothes, ICON_OVERLAY)

		preview_south = new(preview_icon, dir = SOUTH)
		preview_north = new(preview_icon, dir = NORTH)
		preview_east  = new(preview_icon, dir = EAST)
		preview_west  = new(preview_icon, dir = WEST)

		qdel(eyes)
		qdel(underwear)
		qdel(undershirt)
		qdel(clothes)