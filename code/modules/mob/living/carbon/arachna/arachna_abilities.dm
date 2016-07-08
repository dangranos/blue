var/state = 0

// Free abilities.
mob/living/carbon/human/arachna/proc/prepare_bite(mob/living/carbon/human/M as mob in oview(1))
	set name = "Prepare Bite"
	set desc = "Prepare to bite for poising someone"
	set category = "Abilities"

	var/obj/item/organ/internal/arachna/poison_gland/I = internal_organs_by_name["poison_gland"]

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled || !I.reagents  || !I.poisons.len)
		src << "You cannot bite in your current state."
		return
	else if (get_dist(src,M) > 1)
		src << "<span class='alium'>You need to be closer.</span>"
		return

	msg_admin_attack("[key_name_admin(src)] bite and poison [key_name_admin(M)] with [I.reagents.get_reagents()] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	I.reagents.trans_to_mob(M, I.reagents.total_volume, CHEM_BLOOD)
	visible_message("<span class='warning'>[src] bite [M]!</span>", "<span class='alium'>You bite a [M].</span>")
	return

/*mob/living/carbon/human/arachna/proc/prepare_bite()
	set name = "Prepare Bite"
	set desc = "Prepare to bite for poising someone"
	set category = "Abilities"
	var/obj/item/organ/internal/arachna/poison_gland/I = internal_organs_by_name["poison_gland"]
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled || !I.reagents  || !I.poisons.len)
		src << "You cannot bite in your current state."
		return

	if (I.bite_ready)
		I.bite_ready = 1
		src << "You prepare a bite."
	else
		I.bite_ready = 0
		src << "You not want bite anyone now."

	return*/

/*/mob/living/carbon/human/arachna/UnarmedAttack(mob/living/carbon/human/M as mob)
	var/obj/item/organ/internal/arachna/poison_gland/I = internal_organs_by_name["poison_gland"]
	if (src.bite_ready)
		msg_admin_attack("[key_name_admin(src)] bite and poison [key_name_admin(M)] with [I.reagents.get_reagents()] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		I.reagents.trans_to_mob(M, I.reagents.total_volume, CHEM_BLOOD)
		visible_message("<span class='warning'>[src] bite [M]!</span>", "<span class='alium'>You bite a [M].</span>")
		I.bite_ready = 0
	else
		..()*/


var/list/venom_list = list(
	"inaprovaline",
	"stoxin",
	"chloralhydrate",
	"synaptizine",
	"paroxetine",
	"kurovasicin",
	"space_drugs",
	"potassium_chlorophoride",
	"cryptobiolin",
	"tramadol",
	"impedrezene"
)

var/list/added_venoms = list ()

mob/living/carbon/human/arachna/verb/add_venom()
	set name = "Add Venom"
	set desc = "Add Venom"
	set category = "Abilities"

	var/choice = input("Add Venom","Add Venom") in venom_list
	if(!choice)
		return
	added_venoms.Add(choice)
	venom_list.Remove(choice)
	var/obj/item/organ/internal/arachna/poison_gland/I = internal_organs_by_name["poison_gland"]
	I.init(added_venoms)

mob/living/carbon/human/arachna/verb/remove_venom()
	set name = "Remove Venom"
	set desc = "Remove Venom"
	set category = "Abilities"
	var/choice = input("Remove current Venom","Remove Venom") in added_venoms
	if(!choice)
		return
	added_venoms.Remove(choice)
	venom_list.Add(choice)
	var/obj/item/organ/internal/arachna/poison_gland/I = internal_organs_by_name["poison_gland"]
	I.init(added_venoms)

/mob/living/carbon/human/arachna/proc/use_silk_gland() // -- TLE
	set name = "Use silk gland"
	set desc = "Use you spider power to make you home!."
	set category = "Abilities"
	var/obj/item/organ/internal/arachna/silk_gland/I = internal_organs_by_name["silk_gland"]
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot use web in your current state."
		return
	var/choice = input("Choose what you wish to build.","Web building") as null|anything in list("arachna nest", "sticky web", "cancel") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
	if(!choice || choice == "cancel")
		return
	if (I.silk < 10)
		src << "\red You don't have enough web stored to do that."
		return
	I.silk = I.silk - 10
	visible_message("<span class='warning'><B>[src] use spider power and begins build!</B></span>", "<span class='alium'>You build a [choice].</span>")
	switch(choice)
		if("arachna nest")
			new /obj/structure/bed/nest/arachna_nest(loc)
		if ("sticky web")
			new /obj/effect/spider/stickyweb(loc)

	return


/obj/item/weapon/energy_net/arachna_net
	name = "silk net"
	desc = "It's a net made of spider silk."


//	category = !category
//	usr << "You [category ? "enable" : "disable"] your bite ability."




/*if (get_dist(src,M) <= 1)
		src << "<span class='alium'>You need to be closer.</span>"
		return

//	var/obj/item/organ/internal/xenos/plasmavessel/I = M.internal_organs_by_name["plasma vessel"]
//	if(!istype(I))
//		src << "<span class='alium'>Their plasma vessel is missing.</span>"
//		return

	var/amount = input("Amount:", "Transfer Plasma to [M]") as num
	if (amount)
		amount = abs(round(amount))
		if(check_alien_ability(amount,0,"plasma vessel"))
			M.gain_plasma(amount)
			M << "<span class='alium'>[src] has transfered [amount] plasma to you.</span>"
			src << "<span class='alium'>You have transferred [amount] plasma to [M].</span>"
	return
*/