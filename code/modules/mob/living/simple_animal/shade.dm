/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit."
	gender = PLURAL
	icon = 'icons/mob/cult.dmi'
	icon_state = "shade_cult"
	icon_living = "shade_cult"
	mob_biotypes = list(MOB_SPIRIT)
	maxHealth = 40
	health = 40
	spacewalk = TRUE
	healable = 0
	speak_emote = list("hisses")
	emote_hear = list("wails.","screeches.")
	response_help_continuous = "puts their hand through"
	response_help_simple = "put your hand through"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	speak_chance = 1
	melee_damage = 5
	attack_verb_continuous = "metaphysically strikes"
	attack_verb_simple = "metaphysically strike"
	minbodytemp = 0
	maxbodytemp = INFINITY
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	stop_automated_movement = 1
	status_flags = 0
	faction = list(FACTION_CULT)
	status_flags = CANPUSH
	is_flying_animal = TRUE
	loot = list(/obj/item/ectoplasm)
	del_on_death = TRUE
	initial_language_holder = /datum/language_holder/construct
	chat_color = "#FF6262"
	mobchatspan = "cultmobsay"
	discovery_points = 1000

/mob/living/simple_animal/shade/death()
	deathmessage = "lets out a contented sigh as [p_their()] form unwinds."
	..()

/mob/living/simple_animal/shade/canSuicide()
	if(istype(loc, /obj/item/soulstone)) //do not suicide inside the soulstone
		return 0
	return ..()

/mob/living/simple_animal/shade/attack_animal(mob/living/simple_animal/M)
	if(isconstruct(M))
		var/mob/living/simple_animal/hostile/construct/C = M
		if(!C.can_repair_constructs)
			return
		if(health < maxHealth)
			adjustHealth(-25)
			Beam(M, icon_state="sendbeam", time= 4)
			M.visible_message(span_danger("[M] heals \the <b>[src]</b>."), \
					   span_cult("You heal <b>[src]</b>, leaving <b>[src]</b> at <b>[health]/[maxHealth]</b> health."))
		else
			to_chat(M, span_cult("You cannot heal <b>[src]</b>, as [p_theyre()] unharmed!"))
	else if(src != M)
		return ..()

/mob/living/simple_animal/shade/attackby(obj/item/O, mob/user, params)  //Marker -Agouri
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/SS = O
		SS.transfer_soul("SHADE", src, user)
	else
		. = ..()
