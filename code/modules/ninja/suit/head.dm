/obj/item/clothing/head/helmet/space/space_ninja
	desc = "What may appear to be a simple black garment is in fact a highly sophisticated nano-weave helmet. Standard issue ninja gear."
	name = "ninja hood"
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	armor_type = /datum/armor/space_space_ninja
	strip_delay = 12
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	blockTracking = TRUE//Roughly the only unique thing about this helmet.
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR


/datum/armor/space_space_ninja
	melee = 60
	bullet = 50
	laser = 30
	energy = 15
	bomb = 30
	bio = 100
	rad = 25
	fire = 100
	acid = 100
	stamina = 60
	bleed = 60
