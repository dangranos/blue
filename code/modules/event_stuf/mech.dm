/obj/structure/tree_mech
	name = "New Year Tree"
	icon = 'icons/mech.dmi'
	icon_state = "base"
	density = 1
	anchored = 1
	pixel_y = -32
	pixel_x = -32
	var/locked = 1
	var/broken = 0
	var/santa_protect = 1
	var/mob/living/carbon/human/occupant = null

/obj/structure/tree_mech/New()
	for(var/turf/T in orange(1))
		new/obj/structure/tree_mech_part(T)

/obj/structure/tree_mech/verb/move_inside()
	set category = "Object"
	set name = "Enter Exosuit"
	set src in oview(2)
	if (usr.stat || !ishuman(usr))
		return
	if(locked)
		usr << "\red Santa mech is locked"
		return
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			usr << "\red Kinda hard to climb in while handcuffed don't you think?"
			return
	if (occupant)
		usr << "\blue <B>The [src.name] is already occupied!</B>"
		return

	visible_message("\blue [usr] starts to climb into [src.name]")

	if(enter_after(40,usr))
		if(!src.occupant)
			moved_inside(usr)
		else if(src.occupant!=usr)
			usr << "[src.occupant] was faster. Try better next time, loser."
	else
		usr << "You stop entering the exosuit."
	return

/obj/structure/tree_mech/proc/enter_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = user.loc
	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !user.canmove || !(user.loc == T))
			return 0

	return 1

/obj/structure/tree_mech/proc/moved_inside(var/mob/living/carbon/human/H as mob)
	if(H && H.client && H in range(2))
		if(santa_protect && H.species.name != "Santa")
			usr << "\red You are not Santa!"
			return 0
		H.reset_view(src)
		H.stop_pulling()
		H.forceMove(src)
		src.occupant = H
		src.add_fingerprint(H)
		src.forceMove(src.loc)
		return 1
	else
		return 0



/obj/structure/tree_mech/verb/eject()
	set name = "Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	src.go_out()
	add_fingerprint(usr)
	return


/obj/structure/tree_mech/proc/go_out()
	if(!src.occupant) return
	if(occupant.forceMove(get_step(src.loc, SOUTH)))
		occupant.reset_view()
		src.occupant = null


/obj/structure/tree_mech/relaymove()
	if(broken) return
	playsound(src.loc, 'sound/mecha/new_year_tree.ogg', 50, 1, -6)
	icon_state = "end"
	flick("animate",src)
	broken = 1

/obj/structure/tree_mech_part
	density = 1
	anchored = 1
	invisibility = 101

