#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = "/obj/machinery/power/smes/buildable"
	board_type = "machine"
	origin_tech = "powerstorage=6;engineering=4"
	req_components = list("/obj/item/weapon/smes_coil" = 1, "/obj/item/stack/cable_coil" = 30)

/obj/item/weapon/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = "/obj/machinery/power/smes/batteryrack"
	board_type = "machine"
	origin_tech = "powerstorage=3;engineering=2"
	req_components = list("/obj/item/weapon/cell" = 3)

/obj/item/weapon/circuitboard/ghettosmes
	name = T_BOARD("makeshift PSU")
	desc = "An APC circuit repurposed into some power storage device controller"
	build_path = "/obj/machinery/power/smes/batteryrack/makeshift"
	board_type = "machine"
	req_components = list("/obj/item/weapon/cell" = 3)


//TODO: rewrite this!
/obj/item/weapon/circuitboard/ghettosmes/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/device/multitool))
		var/obj/item/weapon/module/power_control/newcircuit = new (user.loc)
		qdel(src)
		user.put_in_hands(newcircuit)