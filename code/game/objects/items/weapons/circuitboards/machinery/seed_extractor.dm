#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/seed_extractor
	name = T_BOARD("seed_extractor")
	build_path = "/obj/machinery/seed_extractor"
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1)