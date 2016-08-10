/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/weapon/circuitboard/autolathe
	var/list/machine_recipes
	var/list/stored_material =  list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0
	
	var/screen = 1
	var/list/datum/autolathe/recipe/queue = list()
	var/list/queue_multiplier = list()
	var/progress = 0

	var/mat_efficiency = 1
	var/build_time = 5
	var/speed

	var/datum/wires/autolathe/wires = null

/obj/machinery/autolathe/New()
	..()
	wires = new(src)
	circuit = new circuit(src)
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/autolathe/process()
	..()
	if(stat)
		update_icon()
		return
	if(queue.len == 0)
		busy = 0
		progress = 0
		update_icon()
		return
	var/datum/autolathe/recipe/R = queue[1]
	if(canBuild(R, (R.is_stack ? queue_multiplier[1] : 1)))
		busy = 1
		progress += speed
		if(progress >= build_time)
			build(R, (R.is_stack ? queue_multiplier[1] : 1))
			progress = 0
			removeFromQueue(1, (R.is_stack ? queue_multiplier[1] : 1))
		update_icon()
	else
		if(busy)
			visible_message("<span class='notice'>\icon [src] flashes: insufficient materials: [getLackingMaterials(R)].</span>")
		busy = 0
	update_icon()

/obj/machinery/autolathe/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = autolathe_recipes

/obj/machinery/autolathe/interact(mob/user as mob)

	update_recipe_list()

	if(..() || (disabled && !panel_open))
		user << "<span class='danger'>\The [src] is disabled!</span>"
		return

	if(shocked)
		shock(user, 50)

	var/dat = ""

	if(!disabled)
		switch(screen)
			if(1) //Main menu
				dat += "<A href='?src=\ref[src];menu=2'>View Queue</A><hr>"
				dat += "Stored materials:<BR>"
				dat += "<center><table width = '100%'>"
				var/material_top = "<tr>"
				var/material_bottom = "<tr>"
				for(var/material in stored_material)
					material_top += "<td width = '25%' align = center><b>[material]</b></td>"
					material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"
				dat += "[material_top]</tr>[material_bottom]</tr><UL>"
				dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

				var/index = 0
				for(var/datum/autolathe/recipe/R in machine_recipes)
					index++
					if(R.hidden && !hacked || (show_category != "All" && show_category != R.category))
						continue
					var/can_make = 1
					var/material_string = ""
					var/multiplier_string = ""
					var/max_sheets
					var/comma
					if(!R.resources || !R.resources.len)
						material_string = "No resources required.</td>"
					else
						//Make sure it's buildable and list requires resources.
						for(var/material in R.resources)
							var/sheets = round(stored_material[material]/round(R.resources[material]*mat_efficiency))
							var/enough = 1
							if(isnull(max_sheets) || max_sheets > sheets)
								max_sheets = sheets
							if(!isnull(stored_material[material]) && stored_material[material] < round(R.resources[material]*mat_efficiency))
								can_make = 0
								enough = 0
								material_string += "<font color = 'red'>"
							if(!comma)
								comma = 1
							else
								material_string += ", "
							material_string += "[round(R.resources[material] * mat_efficiency)] [material]"
							if(!enough)
								material_string += "</font>"
						material_string += "<br></td>"
						//Build list of multipliers for sheets.
						multiplier_string  += "<br>"
						if(R.is_stack)
							for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
								multiplier_string  += "<a href='?src=\ref[src];make=[index];multiplier=[i]'>\[x[i]\]</a>"
							multiplier_string  += "<a href='?src=\ref[src];make=[index];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"
						else
							for(var/i in list(2,5,10))
								multiplier_string  += "<a href='?src=\ref[src];make=[index];multiplier=[i]'>\[x[i]\]</a>"
					dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>!</font>" : ""]<b>[!can_make ? "<font color='red'>" : ""]<a href='?src=\ref[src];make=[index];multiplier=1'>[R.name]</a>[!can_make ? "</font>" : "" ]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>" //"

				dat += "</table><hr>"
			if(2) //Query control menu
				dat += "<A href='?src=\ref[src];menu=1'>Autolathe Menu</A><HR>"
				dat += "Queue:<BR><HR>"
				if(!queue.len)
					dat += "<b>Empty</b>"
				else
					var/tmp = 0
					for(var/datum/autolathe/recipe/R in queue)
						tmp++
						if(tmp == 1)
							if(busy)
								dat += "<B>1: </b><font color='gray'>[queue_multiplier[tmp]]</font> x <b>[R.name]</B>"
								if(queue_multiplier[tmp]>1)
									dat += "(Remove:"
									for(var/amount in list(1,2,5,10))
										if(amount < queue_multiplier[tmp])
											dat += " <A href='?src=\ref[src];remove_pos=[tmp];multiplier=[amount]'>[amount]</A>"
									dat += ")"
								dat += "<br>"
								continue
							else
								dat += "<B>1: </b><font color='gray'>[queue_multiplier[tmp]]</font> x <b>[R.name]</B> (Awaiting materials) (Remove: "
						else
							dat += "[tmp]: <font color='gray'>[queue_multiplier[tmp]]</font> x [R.name] (Remove:"
						for(var/amount in list(1,2,5,10))
							if(amount < queue_multiplier[tmp])
								dat += " <A href='?src=\ref[src];remove_pos=[tmp];multiplier=[amount]'>[amount]</A>"
						dat += " <A href='?src=\ref[src];remove_pos=[tmp];multiplier=[queue_multiplier[tmp]]'>ALL</A>)"
						dat += "<BR>"
	//Hacking. 
	if(panel_open)
		dat += "<h2>Maintenance Panel</h2>"
		dat += wires.GetInteractWindow()

		dat += "<hr>"

	user << browse(dat, "window=autolathe")
	onclose(user, "autolathe")

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(busy)
		user << "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>"
		return

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(stat)
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(istype(O, /obj/item/device/multitool) || istype(O, /obj/item/weapon/wirecutters))
			attack_hand(user)
			return

	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return 0

	if(is_robot_module(O))
		return 0

	if(istype(O,/obj/item/ammo_magazine/clip) || istype(O,/obj/item/ammo_magazine/a357) || istype(O,/obj/item/ammo_magazine/c38)) // Prevents ammo recycling exploit with speedloaders.
		user << "\The [O] is too hazardous to recycle with the autolathe!"
		return
		/*  ToDo: Make this actually check for ammo and change the value of the magazine if it's empty. -Spades
		var/obj/item/ammo_magazine/speedloader = O
		if(speedloader.stored_ammo)
			user << "\The [speedloader] is too hazardous to put back into the autolathe while there's ammunition inside of it!"
			return
		else
			speedloader.matter = list(DEFAULT_WALL_MATERIAL = 75) // It's just a hunk of scrap metal now.
	if(istype(O,/obj/item/ammo_magazine)) // This was just for immersion consistency with above.
		var/obj/item/ammo_magazine/mag = O
		if(mag.stored_ammo)
			user << "\The [mag] is too hazardous to put back into the autolathe while there's ammunition inside of it!"
			return*/

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		user << "\The [eating] does not contain significant amounts of useful materials and cannot be accepted."
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		user << "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>"
		return
	else if(filltype == 1)
		user << "You fill \the [src] to capacity with \the [eating]."
	else
		user << "You fill \the [src] with \the [eating]."

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(O)
		qdel(O)

	updateUsrDialog()
	return

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/proc/addToQueue(var/datum/autolathe/recipe/R, var/multiplier)
	queue += R
	queue_multiplier += multiplier
	return

/obj/machinery/autolathe/proc/removeFromQueue(var/index, var/multiplier)
	queue_multiplier[index] -= multiplier
	if(queue_multiplier[index] < 1)
		queue.Cut(index, index + 1)
		queue_multiplier.Cut(index, index + 1)

/obj/machinery/autolathe/proc/canBuild(var/datum/autolathe/recipe/R, var/multiplier=1)
	for(var/material in R.resources)
		if(!isnull(stored_material[material]))
			if(stored_material[material] < (round(R.resources[material] * mat_efficiency) * multiplier))
				return 0
		else
			return 0
	return 1

/obj/machinery/autolathe/proc/getLackingMaterials(var/datum/autolathe/recipe/R)
	var/ret = ""
	for(var/M in R.resources)
		if(stored_material[M] < R.resources[M])
			if(ret != "")
				ret += ", "
			ret += "[R.resources[M] - stored_material[M]] [M]"
	return ret

/obj/machinery/autolathe/proc/build(var/datum/autolathe/recipe/R, multiplier)
	if(!canBuild(R, multiplier))
		return
	var/power = active_power_usage
	for(var/M in R.resources)
		power += round(R.resources[M] / 5)
	power = max(active_power_usage, power)
	use_power(power)

	for(var/material in R.resources)
		stored_material[material] = max(0, stored_material[material] - round(R.resources[material] * mat_efficiency) * multiplier)

	var/obj/item/I = new R.path(loc)
	if(multiplier && (multiplier > 1) && istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		S.amount = multiplier

/obj/machinery/autolathe/Topic(href, href_list)

	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)
	
	if(href_list["menu"])
		screen = text2num(href_list["menu"])
		if(screen<0 || screen>2)
			screen = 1
	
	if(href_list["remove_pos"])
		var/queue_pos = text2num(href_list["remove_pos"])
		var/multiplier = text2num(href_list["multiplier"])
		if((queue_pos < queue.len) && (queue_pos < 1))
			return
		if((queue_pos==1) && (multiplier >= queue_multiplier[1]))
			updateUsrDialog()
			return
		removeFromQueue(queue_pos, multiplier)

	if(href_list["change_category"])

		var/choice = input("Which category do you wish to display?") as null|anything in autolathe_categories+"All"
		if(!choice) return
		show_category = choice

	if(href_list["make"] && machine_recipes)

		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
		var/datum/autolathe/recipe/making

		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!making || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!")
			return

		addToQueue(making, multiplier)
	updateUsrDialog()

/obj/machinery/autolathe/update_icon()
	if(busy)
		icon_state = "autolathe_n"
	else if(panel_open)
		icon_state = "autolathe_t"
	else
		icon_state = "autolathe"

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[DEFAULT_WALL_MATERIAL] = mb_rating  * 25000
	storage_capacity["glass"] = mb_rating  * 12500
	build_time = 5 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3
	speed = man_rating

/obj/machinery/autolathe/dismantle()

	for(var/mat in stored_material)
		var/material/M = get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1
