# define MODIFICATION_ORGANIC 1
# define MODIFICATION_SILICON 2
# define MODIFICATION_REMOVED 3

var/global/list/body_modifications = list()
var/global/list/modifications_list = list(
	"chest" = "",  "chest2" = "", "head" = "",   "groin" = "",
	"l_arm"  = "", "r_arm"  = "", "l_hand" = "", "r_hand" = "",
	"l_leg"  = "", "r_leg"  = "", "l_foot" = "", "r_foot" = "",
	"heart"  = "", "lungs"  = "", "liver"  = "", "eyes"   = ""
)

/proc/generate_body_modification_lists()
	for(var/mod_type in typesof(/datum/body_modification))
		var/datum/body_modification/BM = new mod_type()
		if(!BM.id) continue
		body_modifications[BM.id] += BM
		for(var/part in BM.body_parts)
			modifications_list[part] = "<div onclick=\"set('body_modification', '[BM.id]');\" class='block'><b>[BM.name]</b><br>[BM.desc]</div>" + modifications_list[part]

/proc/get_default_modificaton(var/nature = MODIFICATION_ORGANIC)
	if(nature == MODIFICATION_ORGANIC) return "nothing"
	if(nature == MODIFICATION_SILICON) return "prosthesis_basic"
	if(nature == MODIFICATION_REMOVED) return "amputated"

datum/body_modification
	var/name = "Nothing"
	var/short_name = "Nothing"
	var/id = "nothing"					// For savefile. Must be unique.
	var/desc = "Normal organ"			// Description.
	var/list/body_parts = list("chest", "chest2", "head", "groin", "l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg",\
		"l_foot", "r_foot", "heart", "lungs", "liver", "brain", "eyes")		// For sorting'n'selection optimization.
	var/allowed_species = list("Human")	// Species restriction.
	var/allowed_slim_body = 1			// The "main sprite question" yeah.
	var/replace_limb = null				// To draw usual limb or not.
	var/mob_icon = ""
	var/nature = MODIFICATION_ORGANIC

	proc/get_mob_icon(organ, body_build = 0)	//Use in setup character only
		return new/icon('icons/mob/human.dmi', "blank")

	proc/is_allowed(datum/preferences/P)
		if(!allowed_slim_body && (P.body_build == BODY_SLIM))
			usr << "[name] isn't allowed for slim body"
			return 0
		if(!(P.current_species.name in allowed_species))
			usr << "[name] isn't allowed for [P.current_species.name]"
			return 0
		if(!(P.current_organ in body_parts))
			usr << "[name] isn't useable for [P.current_organ]"
			return 0
		return 1

	proc/apply_to_mob(var/mob/living/carbon/human/H, var/slot)
		return 1

datum/body_modification/amputation
	name = "Amputated"
	short_name = "Amputated"
	id = "amputated"
	desc = "Organ was removed"
	body_parts = list("l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot")
	replace_limb = 1
	nature = MODIFICATION_REMOVED

datum/body_modification/tattoo
	name = "Abstract"
	short_name = "T: Abstract"
	desc = "Simple tattoo (use flavor)."
	id = "abstract"
	body_parts = list("head", "chest", "groin", "l_arm", "r_arm",\
		"l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot")
	mob_icon = "1"

	New()
		short_name = "T: [name]"
		name = "Tattoo: [name]"

	get_mob_icon(organ, body_build = 0)
		return new/icon('icons/mob/tattoo.dmi', "[organ]_[mob_icon]_[body_build]")

	apply_to_mob(var/mob/living/carbon/human/H, var/slot)
		var/obj/item/organ/external/E = H.organs_by_name[slot]
		if(findtext(slot, "2"))
			E.tattoo2 = mob_icon
		else
			E.tattoo = mob_icon

datum/body_modification/prosthesis
	name = "Unbranded"
	id = "prosthesis_basic"
	desc = "Simple, brutal and reliable prosthesis"
	body_parts = list("l_arm", "r_arm", "l_hand", "r_hand", \
		"l_leg", "r_leg", "l_foot", "r_foot")
	replace_limb = 1
	mob_icon = "base"
	nature = MODIFICATION_SILICON

	New()
		short_name = "P: [name]"
		name = "Prosthesis: [name]"

	get_mob_icon(organ, body_build = 0)
		return new/icon('icons/mob/human_races/body_modification.dmi', "[organ]_[mob_icon]_[body_build]")

datum/body_modification/prosthesis/bishop
	name = "Bishop"
	id = "prosthesis_bishop"
	desc = "Prosthesis with white polymer casing with blue holo-displays."

	get_mob_icon(organ, body_build = 0)
		return new/icon('icons/mob/human_races/cyberlimbs/bishop.dmi', "[organ]_f[body_build]")

datum/body_modification/prosthesis/hesphaistos
	name = "Hesphaistos"
	id = "prosthesis_hesphaistos"
	desc = "Prosthesis with militaristic black and green casing with gold stripes."

	get_mob_icon(organ, body_build = 0)
		return new/icon('icons/mob/human_races/cyberlimbs/hesphaistos.dmi', "[organ]_f[body_build]")

datum/body_modification/prosthesis/zenghu
	name = "Zeng-Hu"
	id = "prosthesis_zenghu"
	desc = "Prosthesis with rubbery fleshtone covering with visible seams."
	allowed_slim_body = 0

	get_mob_icon(organ, body_build = 0)
		return new/icon('icons/mob/human_races/cyberlimbs/zenghu.dmi', "[organ]_m[body_build]")

datum/body_modification/prosthesis/xion
	name = "Xion"
	id = "prosthesis_xion"
	desc = "Prosthesis with minimalist black and red casing."

	get_mob_icon(organ, body_build = 0)
		return new/icon('icons/mob/human_races/cyberlimbs/xion.dmi', "[organ]_f[body_build]")

datum/body_modification/mutation
	name = "Exoskeleton"
	id = "mutation_exoskeleton"
	desc = "Your limb covered with bony shell (act as shield)."
	body_parts = list("head", "chest", "groin", "l_arm", "r_arm",\
		"l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot")

	New()
		short_name = "M: [name]"
		name = "Mutation: [name]"

datum/body_modification/mutation/heterochromia
	name = "Heterochromia"
	id = "mutation_heterochromia"
	desc = "Special color for right eye."
	body_parts = list("eyes")


# undef MODIFICATION_REMOVED
# undef MODIFICATION_ORGANIC
# undef MODIFICATION_SILICON