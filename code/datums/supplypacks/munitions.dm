/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_packs/munitions
	group = "Munitions"

/datum/supply_packs/randomised/munitions
	group = "Munitions"
	access = access_security

/datum/supply_packs/munitions/weapons
	name = "Weapons crate"
	contains = list(
			/obj/item/weapon/melee/baton = 2,
			/obj/item/weapon/gun/energy/laspistol = 3,
			/obj/item/weapon/gun/projectile/colt/detective = 1,
			/obj/item/weapon/storage/box/teargas = 1
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"

/datum/supply_packs/munitions/flareguns
	name = "Flare guns crate"
	contains = list(
			/obj/item/weapon/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/c45m/flash,
			/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/weapon/storage/box/flashshells
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Flare gun crate"

/datum/supply_packs/munitions/eweapons
	name = "Experimental weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/xray = 2,
			/obj/item/weapon/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Experimental weapons crate"
	access = access_armory

/datum/supply_packs/munitions/energyweapons
	name = "Energy weapons crate"
	contains = list(/obj/item/weapon/gun/energy/lasrifle = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "energy weapons crate"
	access = access_armory

/datum/supply_packs/munitions/shotgun
	name = "Shotgun crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo,
			/obj/item/weapon/storage/box/shotgunshells,
			/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	access = access_armory

/datum/supply_packs/munitions/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy marksman crate"
	access = access_armory

/datum/supply_packs/munitions/ionweapons
	name = "Electromagnetic weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle = 2,
			/obj/item/weapon/storage/box/emps
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "electromagnetic weapons crate"
	access = access_armory

/datum/supply_packs/munitions/bolt_rifles_competitive
 	name = "Competitive shooting crate"
 	contains = list(
 			/obj/item/device/assembly/timer,
 			/obj/item/weapon/gun/projectile/shotgun/pump/rifle/practice = 2,
 			/obj/item/ammo_magazine/clip/a762/practice = 4,
 			/obj/item/target = 2,
 			/obj/item/target/alien = 2,
 			/obj/item/target/syndicate = 2
 			)
 	cost = 40
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Weapons crate"

/datum/supply_packs/munitions/shotgunammo
	name = "Shotgun ammunition crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo = 2,
			/obj/item/weapon/storage/box/shotgunshells = 2
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic ammunition crate"
	access = access_armory

/datum/supply_packs/randomised/munitions/lowcalammo
	name = "Low caliber ammo crate"
	num_contained = 8
	contains = list(
			/obj/item/ammo_magazine/a357,
			/obj/item/ammo_magazine/c45m,
			/obj/item/ammo_magazine/mc9mm
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon ammunition crate"
	access = access_armory

/datum/supply_packs/randomised/munitions/heavycalammo
	name = "Heavy caliber ammo crate"
	num_contained = 8
	contains = list(
			/obj/item/ammo_magazine/a10mm,
			/obj/item/ammo_magazine/a556,
			/obj/item/ammo_magazine/a556m,
			/obj/item/ammo_magazine/c762,
			/obj/item/ammo_magazine/g12
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon ammunition crate"
	access = access_armory

