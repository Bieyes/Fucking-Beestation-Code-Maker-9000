/obj/item/melee/transforming/energy
	icon = 'icons/obj/transforming_energy.dmi'
	hitsound_on = 'sound/weapons/blade1.ogg'
	heat = 3500
	max_integrity = 200
	armor_type = /datum/armor/transforming_energy
	resistance_flags = FIRE_PROOF
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE
	var/sword_color


/datum/armor/transforming_energy
	fire = 100
	acid = 30

/obj/item/melee/transforming/energy/Initialize(mapload)
	. = ..()
	if(active)
		START_PROCESSING(SSobj, src)

/obj/item/melee/transforming/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/melee/transforming/energy/suicide_act(mob/living/user)
	if(!active)
		transform_weapon(user, TRUE)
	user.visible_message(span_suicide("[user] is [pick("slitting [user.p_their()] stomach open with", "falling on")] [src]! It looks like [user.p_theyre()] trying to commit seppuku!"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/melee/transforming/energy/add_blood_DNA(list/blood_dna)
	return FALSE

/obj/item/melee/transforming/energy/is_sharp()
	return active * sharpness

/obj/item/melee/transforming/energy/process()
	open_flame()

/obj/item/melee/transforming/energy/transform_weapon(mob/living/user, supress_message_text)
	. = ..()
	if(.)
		if(active)
			if(sword_color)
				icon_state = "sword[sword_color]"
			START_PROCESSING(SSobj, src)
		else
			STOP_PROCESSING(SSobj, src)
		set_light_on(active)


/obj/item/melee/transforming/energy/is_hot()
	return active * heat

/obj/item/melee/transforming/energy/ignition_effect(atom/A, mob/user)
	if(!active)
		return ""

	var/in_mouth = ""
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.wear_mask)
			in_mouth = ", barely missing [C.p_their()] nose"
	. = span_warning("[user] swings [user.p_their()] [name][in_mouth]. [user.p_they(TRUE)] light[user.p_s()] [user.p_their()] [A.name] in the process.")
	playsound(loc, hitsound, get_clamped_volume(), TRUE, -1)
	add_fingerprint(user)

/obj/item/melee/transforming/energy/axe
	name = "energy axe"
	desc = "An energized battle axe."
	icon_state = "axe0"
	lefthand_file = 'icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/axes_righthand.dmi'
	force = 40
	force_on = 150
	throwforce = 25
	throwforce_on = 30
	hitsound = 'sound/weapons/bladeslice.ogg'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	w_class_on = WEIGHT_CLASS_HUGE
	flags_1 = CONDUCT_1
	armour_penetration = 100
	attack_verb_off = list("attacks", "chops", "cleaves", "tears", "lacerates", "cuts")
	attack_verb_on = list()
	light_color = "#40ceff"

/obj/item/melee/transforming/energy/axe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] swings [src] towards [user.p_their()] head! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/melee/transforming/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 3
	throwforce = 5
	throwforce_on = 35	//Does a lot of damage on throw, but will embed
	hitsound = "swing_hit" //it starts deactivated
	attack_verb_off = list("taps", "pokes")
	throw_speed = 3
	throw_range = 5
	sharpness = SHARP_DISMEMBER_EASY
	bleed_force_on = BLEED_DEEP_WOUND
	embedding = list("embed_chance" = 200, "armour_block" = 60, "max_pain_mult" = 15)
	armour_penetration = 35
	block_level = 1
	block_upgrade_walk = 1
	block_power = 35
	block_sound = 'sound/weapons/egloves.ogg'
	block_flags = BLOCKING_ACTIVE | BLOCKING_NASTY

/obj/item/melee/transforming/energy/sword/transform_weapon(mob/living/user, supress_message_text)
	. = ..()
	if(. && active && sword_color)
		icon_state = "sword[sword_color]"

/obj/item/melee/transforming/energy/sword/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(active)
		return ..()
	return 0

/obj/item/melee/transforming/energy/sword/esaw //Energy Saw on it's own
	name = "energy saw"
	desc = "For heavy duty cutting. It has a carbon-fiber blade in addition to a toggleable hard-light edge to dramatically increase sharpness."
	force_on = 30
	force = 18 //About as much as a spear
	hitsound = 'sound/weapons/circsawhit.ogg'
	icon = 'icons/obj/surgery.dmi'
	icon_state = "esaw_0"
	icon_state_on = "esaw_1"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	sword_color = null //stops icon from breaking when turned on.
	w_class = WEIGHT_CLASS_NORMAL
	sharpness = SHARP_DISMEMBER_EASY
	bleed_force_on = BLEED_DEEP_WOUND
	light_color = "#40ceff"
	tool_behaviour = TOOL_SAW
	toolspeed = 0.7 //faster as a saw

/obj/item/melee/transforming/energy/sword/cyborg
	sword_color = "red"
	var/hitcost = 50

/obj/item/melee/transforming/energy/sword/cyborg/attack(mob/M, var/mob/living/silicon/robot/R)
	if(R.cell)
		var/obj/item/stock_parts/cell/C = R.cell
		if(active && !(C.use(hitcost)))
			attack_self(R)
			balloon_alert(R, "Your [name] is out of charge.")
			return
		return ..()

/obj/item/melee/transforming/energy/sword/cyborg/saw //Used by medical Syndicate cyborgs
	name = "energy saw"
	desc = "For heavy duty cutting. It has a carbon-fiber blade in addition to a toggleable hard-light edge to dramatically increase sharpness."
	force_on = 30
	force = 18 //About as much as a spear
	hitsound = 'sound/weapons/circsawhit.ogg'
	icon = 'icons/obj/surgery.dmi'
	icon_state = "implant-esaw_0"
	icon_state_on = "implant-esaw_1"
	sword_color = null //stops icon from breaking when turned on.
	hitcost = 75 //Costs more than a standard cyborg esword
	w_class = WEIGHT_CLASS_NORMAL
	sharpness = SHARP_DISMEMBER_EASY
	bleed_force_on = BLEED_DEEP_WOUND
	light_color = "#40ceff"
	tool_behaviour = TOOL_SAW
	toolspeed = 0.7 //faster as a saw

/obj/item/melee/transforming/energy/sword/cyborg/saw/cyborg_unequip(mob/user)
	if(!active)
		return
	transform_weapon(user, TRUE)

/obj/item/melee/transforming/energy/sword/cyborg/saw/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return 0

/obj/item/melee/transforming/energy/sword/esaw/implant //Energy Saw Arm Implant
	icon_state = "implant-esaw_0"
	icon_state_on = "implant-esaw_1"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'


/obj/item/melee/transforming/energy/sword/saber
	var/list/possible_colors = list("red" = LIGHT_COLOR_RED, "blue" = LIGHT_COLOR_LIGHT_CYAN, "green" = LIGHT_COLOR_GREEN, "purple" = LIGHT_COLOR_LAVENDER)
	var/hacked = FALSE

/obj/item/melee/transforming/energy/sword/saber/Initialize(mapload)
	. = ..()
	if(LAZYLEN(possible_colors))
		var/set_color = pick(possible_colors)
		sword_color = set_color
		light_color = possible_colors[set_color]

/obj/item/melee/transforming/energy/sword/saber/process()
	. = ..()
	if(hacked)
		var/set_color = pick(possible_colors)
		light_color = possible_colors[set_color]

/obj/item/melee/transforming/energy/sword/saber/red
	possible_colors = list("red" = LIGHT_COLOR_RED)

/obj/item/melee/transforming/energy/sword/saber/blue
	possible_colors = list("blue" = LIGHT_COLOR_LIGHT_CYAN)

/obj/item/melee/transforming/energy/sword/saber/green
	possible_colors = list("green" = LIGHT_COLOR_GREEN)

/obj/item/melee/transforming/energy/sword/saber/purple
	possible_colors = list("purple" = LIGHT_COLOR_LAVENDER)

/obj/item/melee/transforming/energy/sword/saber/attackby(obj/item/W, mob/living/user, params)
	if(W.tool_behaviour == TOOL_MULTITOOL)
		if(!hacked)
			hacked = TRUE
			sword_color = "rainbow"
			balloon_alert(user, "RNBW_ENGAGE")

			if(active)
				icon_state = "swordrainbow"
				user.update_inv_hands()
		else
			balloon_alert(user, "It's already fabulous!")
	else
		return ..()

/obj/item/melee/transforming/energy/sword/bee  //yeah its fucking stupid but I wanted a yellow esword which is weaker than what we have
	name = "Bee Sword"
	desc = "Channel the might of the bees with this powerful sword"
	force = 0
	throwforce = 0
	force_on = 22
	throwforce_on = 16
	sword_color = "yellow"
	light_color = "#ffff00"

/obj/item/melee/transforming/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	icon_state_on = "cutlass1"
	light_color = "#ff0000"

/obj/item/melee/transforming/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 30 //Normal attacks deal esword damage
	hitsound = 'sound/weapons/blade1.ogg'
	active = 1
	throwforce = 1 //Throwing or dropping the item deletes it.
	throw_speed = 3
	throw_range = 1
	w_class = WEIGHT_CLASS_BULKY//So you can't hide it in your pocket or some such.
	var/datum/effect_system/spark_spread/spark_system
	sharpness = SHARP_DISMEMBER_EASY
	bleed_force_on = BLEED_DEEP_WOUND

//Most of the other special functions are handled in their own files. aka special snowflake code so kewl
/obj/item/melee/transforming/energy/blade/Initialize(mapload)
	. = ..()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/melee/transforming/energy/blade/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/item/melee/transforming/energy/blade/transform_weapon(mob/living/user, supress_message_text)
	return

/obj/item/melee/transforming/energy/blade/hardlight
	name = "hardlight blade"
	desc = "An extremely sharp blade made out of hard light. Packs quite a punch."
	icon_state = "lightblade"
	item_state = "lightblade"
