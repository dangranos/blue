/datum/body_build
	var/name			= "Default"
	var/gender 			= MALE
	var/index			= "" 					// For icon_ovveride body_build supply
	var/uniform_icon	= 'icons/mob/uniform.dmi'
	var/suit_icon		= 'icons/mob/suit.dmi'
	var/gloves_icon		= 'icons/mob/hands.dmi'
	var/glasses_icon	= 'icons/mob/eyes.dmi'
	var/ears_icon		= 'icons/mob/ears.dmi'
	var/mask_icon		= 'icons/mob/mask.dmi'
	var/hat_icon		= 'icons/mob/head.dmi'
	var/shoes_icon		= 'icons/mob/feet.dmi'
	var/misk_icon		= 'icons/mob/mob.dmi'
	var/belt_icon		= 'icons/mob/belt.dmi'
	var/s_store_icon	= 'icons/mob/belt_mirror.dmi'
	var/backpack_icon	= 'icons/mob/back.dmi'
	var/ties_icon		= 'icons/mob/ties.dmi'

/datum/body_build/female
	gender 			= FEMALE

/datum/body_build/neuter
	gender 			= NEUTER

/datum/body_build/slim
	name			= "Slim"
	index			= "_slim"
	gender 			= FEMALE
	uniform_icon	= 'icons/mob/uniform_slim.dmi'
	suit_icon		= 'icons/mob/suit_slim.dmi'
	gloves_icon		= 'icons/mob/hands_slim.dmi'
	glasses_icon	= 'icons/mob/eyes_slim.dmi'
	ears_icon		= 'icons/mob/ears_slim.dmi'
	mask_icon		= 'icons/mob/mask_slim.dmi'
	shoes_icon		= 'icons/mob/feet_slim.dmi'
	belt_icon		= 'icons/mob/belt_slim.dmi'
	backpack_icon	= 'icons/mob/back_slim.dmi'
	ties_icon		= 'icons/mob/ties_slim.dmi'

/proc/get_body_build(gender, body_build = "Default", var/list/limited_to)
	if(limited_to && !(body_build in limited_to))
		body_build = "Default"
	if(body_build in body_builds[gender])
		return body_builds[gender][body_build]
	else
		return body_builds[gender]["Default"]

/proc/get_body_build_list(gender = MALE, limited_to)
	return body_builds[gender]&limited_to