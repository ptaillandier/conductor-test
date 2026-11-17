/**
 * Modèle de simulation d'évacuation d'une plage méditerranéenne face à un tsunami.
 * Ce modèle explore les stratégies de gestion de crise pour minimiser les risques.
 *
 * Auteurs : Agent OpenCode (Corrigé)
 * Date : 2026-11-17
 */

model mon_modele

global {
	// Paramètres du modèle
	int nb_people <- 1000; // Nombre initial de personnes sur la plage
	float beach_width <- 2000.0; // Largeur de la plage en mètres
	float beach_depth <- 200.0; // Profondeur de la plage
	int nb_exits <- 4; // Nombre de sorties sur la digue
	float tsunami_warning_time <- 120.0; // Temps d'alerte avant le tsunami en minutes
	float evacuation_speed <- 1.5; // Vitesse de déplacement des personnes en m/s
	float panic_threshold <- 0.3; // Probabilité de paniquer au moment de l'alerte

	// Ressources opérationnelles & état
	bool alert_triggered <- false;
	bool speakers_active <- false;
	bool cellular_messages_sent <- false;
	int nb_policemen <- 5;
	int evacuated_count <- 0;

	// Lieux importants
	geometry beach_area;
	geometry hill_area;
	list<geometry> exits <- [];
	
	// Définition de la taille de l'environnement (2000m x 1000m)
	geometry shape <- rectangle(beach_width, 1000.0);

	init {
		// Définir la plage (en bas) et la colline (en haut, zone sûre)
		beach_area <- rectangle(beach_width, beach_depth) at_location {beach_width / 2, 850.0};
		hill_area <- rectangle(beach_width, 300.0) at_location {beach_width / 2, 150.0};

		// Création des sorties sur la digue (entre la plage et la colline)
		loop i from: 0 to: (nb_exits - 1) {
			float x_pos <- (beach_width / (nb_exits + 1)) * (i + 1);
			geometry exit_line <- line([{x_pos, 720.0}, {x_pos, 750.0}]);
			add exit_line to: exits;
		}

		// Création des personnes
		create person number: nb_people {
			location <- any_location_in(beach_area);
			knowledge_of_exit <- rnd(nb_exits - 1);
			is_resident <- flip(0.5);
		}

		// Création des policiers
		create policeman number: nb_policemen {
			location <- any_location_in(beach_area);
		}
	}

	// Déclenchement de l'alerte au cycle 1
	reflex trigger_tsunami_alert when: cycle = 1 {
		write "ALERTE : Tsunami imminent !";
		alert_triggered <- true;
		speakers_active <- true;
		cellular_messages_sent <- true;
		
		// Évaluation initiale de la panique au moment de l'alerte
		ask person {
			if (flip(panic_threshold)) {
				is_panicked <- true;
			}
		}
	}
	
	// Arrêt de la simulation quand le temps est écoulé ou que tout le monde est évacué
	reflex stop_simulation when: (time >= (tsunami_warning_time * 60)) or (empty(person)) {
		write "Fin de simulation. Évacués : " + evacuated_count + " / " + nb_people;
		do pause;
	}
}

species person skills: [moving] {
	bool is_panicked <- false;
	bool is_resident;
	int knowledge_of_exit; // Index de la sortie connue dans la liste 'exits'
	bool passed_exit <- false;

	reflex move_to_safety when: alert_triggered {
		if (not is_panicked) {
			point target_point;
			
			if (not passed_exit) {
				// Choix de la sortie selon les canaux d'information
				if (is_resident and cellular_messages_sent) {
					geometry best_exit <- exits closest_to self;
					target_point <- best_exit.location;
				} else if (speakers_active) {
					target_point <- exits[knowledge_of_exit].location;
				} else {
					target_point <- exits[rnd(nb_exits - 1)].location;
				}
				
				do goto target: target_point speed: evacuation_speed;
				
				if ((self distance_to target_point) < 15.0) {
					passed_exit <- true;
				}
			} else {
				// Une fois la digue franchie, monter vers la colline
				do goto target: {location.x, hill_area.location.y} speed: evacuation_speed;
			}
		} else {
			// Comportement de panique : déplacement erratique lent
			do wander speed: evacuation_speed / 2;
		}

		// Vérification de l'arrivée en zone sûre
		if (self intersects hill_area) {
			evacuated_count <- evacuated_count + 1;
			do die;
		}
	}

	aspect circle {
		draw circle(6) color: (is_panicked ? #red : #blue);
	}
}

species policeman skills: [moving] {
	reflex patrol {
		do wander speed: 2.0 bounds: beach_area;
	}

	reflex give_instructions when: alert_triggered {
		// Les policiers calment et orientent les personnes dans un rayon de 50m
		list<person> nearby_people <- person at_distance 50.0;
		loop p over: nearby_people {
			if (p.is_panicked) {
				p.is_panicked <- false;
			}
			// Assigne l'index de la sortie la plus proche de la personne
			geometry closest_exit <- exits closest_to p;
			p.knowledge_of_exit <- exits index_of closest_exit;
		}
	}

	aspect square {
		draw square(14) color: #yellow border: #black;
	}
}

experiment TsunamiEvacuation type: gui {
	parameter "Nombre de personnes" var: nb_people min: 100 max: 5000;
	parameter "Temps d'alerte (min)" var: tsunami_warning_time min: 30.0 max: 300.0;
	parameter "Vitesse évacuation (m/s)" var: evacuation_speed min: 0.5 max: 3.0;
	parameter "Probabilité de panique" var: panic_threshold min: 0.0 max: 1.0;
	parameter "Nombre de policiers" var: nb_policemen min: 0 max: 20;

	output {
		display main_display type: 2d {
			graphics "Environnement" {
				draw beach_area color: #sandybrown;
				draw hill_area color: #forestgreen;
				loop e over: exits {
					draw e color: #black width: 4;
				}
			}
			species person aspect: circle;
			species policeman aspect: square;
		}

		monitor "Personnes évacuées" value: evacuated_count;
		monitor "Personnes restantes" value: length(person);
		monitor "Personnes en panique" value: person count (each.is_panicked);
	}
}

experiment TsunamiEvacuationBatch type: batch repeat: 5 until: (time >= (tsunami_warning_time * 60)) or empty(person) {
	parameter "Nombre de policiers" var: nb_policemen among: [0, 5, 10, 20];
	parameter "Probabilité de panique" var: panic_threshold among: [0.2, 0.5, 0.8];

	reflex save_results {
		save [int(self), nb_policemen, panic_threshold, evacuated_count, person count (each.is_panicked)] 
			to: "batch_results.csv" format: "csv" rewrite: false header: true;
	}
}