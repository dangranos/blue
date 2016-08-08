var/global/list/limb_icon_cache = list()

/obj/item/organ/external/tiny/featers
	var/h_col = "#000000"       // Hair colour
	var/body_hair = "feathers"  // Icon blend for body hair if any.

/obj/item/organ/external/tiny/featers/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	h_col = human.hair_color

/obj/item/organ/external/tiny/featers/sync_colour_to_dna()
	..()
	h_col = rgb(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))

/obj/item/organ/external/tiny/featers/get_icon_key()
	return (..() + h_col)

/obj/item/organ/external/tiny/featers/get_icon(var/skeletal)
	..()
	if(body_hair && h_col)
		var/cache_key = "[body_hair]-[organ_tag]-[h_col]"
		if(!limb_icon_cache[cache_key])
			var/icon/I = icon(species.get_icobase(owner), "[organ_tag]_[body_hair]")// Body_build. Don't forget.
			I.Blend(h_col, ICON_ADD)
			limb_icon_cache[cache_key] = I
		mob_icon.Blend(limb_icon_cache[cache_key], ICON_OVERLAY)

	dir = EAST
	icon = mob_icon
	return mob_icon
