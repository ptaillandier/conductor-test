/**
 * Modèle de simulation d'évacuation d'une plage méditerranéenne face à un tsunami.
 * Ce modèle explore les stratégies de gestion de crise pour minimiser les risques.
 *
 * Auteurs : Agent OpenCode
 * Date : 2026-11-17
 */

model mon_modele

global {
	// Paramètres du modèle
	int nb_people <- 1000; // Nombre initial de personnes sur la plage
	float beach_width <- 2000.0; // Largeur de la plage en mètres
	int nb_exits <- 4; // Nombre de sorties sur la digue
	float tsunami_warning_time <- 120.0; // Temps d'alerte avant le tsunami en minutes
	float evacuation_speed <- 1.5; // Vitesse de déplacement des personnes en m/s
	float panic_threshold <- 0.7; // Seuil de panique (probabilité de paniquer)

	// Ressources opérationnelles
	bool speakers_active <- false; // Haut-parleurs actifs ou non
	bool cellular_messages_sent <- false; // Messages cellulaires envoyés ou non
	int nb_policemen <- 5; // Nombre de policiers sur la plage

	// Lieux importants
	geometry beach_area;
	geometry hill_area;
	list<geometry> exits;

	init {
		// Initialisation de l'environnement
		create world {
			// Définir la plage et la colline (simplifié pour cet exemple)
			beach_area <- square(beach_width) with_origin {-beach_width / 2, -100};
			hill_area <- square(beach_width) at {-beach_width / 2, 500} with_attributes [color::green];

			// Création des sorties
			loop i from 0 to (nb_exits - 1) {
				exits add line({-beach_width / 2 + (beach_width / (nb_exits + 1)) * (i + 1), 0}, {-beach_width / 2 + (beach_width / (nb_exits + 1)) * (i + 1), 10});
			}
		}

		// Création des personnes
		create person number: nb_people {
			location <- rnd(beach_area); // Position aléatoire sur la plage
			knowledge_of_exit <- rnd(nb_exits - 1); // Connaissance initiale d'une sortie
			is_resident <- flip(0.5); // 50% de chances d'être résident
		}

		// Création des policiers
		create policeman number: nb_policemen {
			location <- rnd(beach_area); // Position aléatoire sur la plage
		}
	}

	reflex tsunami_alert when cycle = 1 { // Alerte au début de la simulation
		do notify (message: "Alerte Tsunami imminente !");
		speakers_active <- true;
		cellular_messages_sent <- true;
	}
}

species person {
	bool is_evacuated <- false;
	bool is_panicked <- false;
	bool is_resident;
	int knowledge_of_exit; // Index de la sortie connue

	reflex move_to_safety when not is_evacuated {
		if (tsunami_alert and not is_panicked) {
			point target_exit;
			if (is_resident and cellular_messages_sent) {
				// Les résidents informés connaissent la meilleure sortie (simplifié ici)
				target_exit <- closest(exits, self).location + {0, 50}; // Se dirige vers la sortie la plus proche puis vers la colline
			} else if (speakers_active) {
				// Les personnes entendant les haut-parleurs se dirigent vers la sortie connue
				target_exit <- exits[knowledge_of_exit].location + {0, 50};
			} else {
				// Sans information, se dirige aléatoirement vers une sortie
				target_exit <- exits[rnd(nb_exits - 1)].location + {0, 50};
			}

			do goto target_exit speed: evacuation_speed;

			if (distance(location, target_exit) < 10) { // Si proche de la sortie
				do goto hill_area.location speed: evacuation_speed;
			}
		} else if (tsunami_alert and is_panicked) {
			// Comportement de panique : mouvement aléatoire ou figé
			do wander speed: evacuation_speed / 2;
		}

		if (intersects(self, hill_area)) {
			is_evacuated <- true;
			do die;
		}

		// Déclenchement de la panique
		if (rnd(1.0) < panic_threshold) {
			is_panicked <- true;
		}
	}
}

species policeman {
	reflex patrol {
		do wander speed: 2.0;
	}

	reflex give_instructions when (tsunami_alert) {
		// Les policiers donnent des instructions aux personnes à proximité
		loop p over: (people in: beach_area) with_distance_le 50 {
			if (p.is_panicked) {
				p.is_panicked <- false; // Calme la personne
				do notify (message: "Policier calme une personne.");
			}
			p.knowledge_of_exit <- closest(exits, p).location.x; // Donne la meilleure direction
		}
	}
}


experiment TsunamiEvacuation type: gui {
	parameter "Nombre de personnes" var: nb_people min: 100 max: 5000;
	parameter "Temps d'alerte (min)" var: tsunami_warning_time min: 30 max: 300;
	parameter "Vitesse évacuation (m/s)" var: evacuation_speed min: 0.5 max: 3.0;
	parameter "Seuil de panique" var: panic_threshold min: 0.0 max: 1.0;
	parameter "Haut-parleurs actifs" var: speakers_active;
	parameter "Messages cellulaires envoyés" var: cellular_messages_sent;
	parameter "Nombre de policiers" var: nb_policemen min: 0 max: 20;


	// Affichage graphique
	display main_display type: opengl {
		species person aspect: circle {
			draw circle(5) color: (is_evacuated ? #green : (is_panicked ? #red : #blue));
		}
		species policeman aspect: square {
			draw square(10) color: #yellow;
		}
		graphics "Plage" {
			draw beach_area color: #orange;
		}
		graphics "Colline" {
			draw hill_area color: #green;
		}
		graphics "Sorties" {
			loop i from 0 to (nb_exits - 1) {
				draw exits[i] color: #black;
			}
		}
	}

	// Moniteurs pour suivre l'évolution
	monitor "Personnes évacuées" value: (nb_people - (person count(each.is_evacuated = false)));
	monitor "Personnes en panique" value: (person count(each.is_panicked = true));
}

experiment TsunamiEvacuationBatch type: batch {
	repeat 5;
	parameter "Nombre de personnes" var: nb_people min: 100 max: 5000;
	parameter "Temps d'alerte (min)" var: tsunami_warning_time min: 30 max: 300;
	parameter "Vitesse évacuation (m/s)" var: evacuation_speed min: 0.5 max: 3.0;
	parameter "Seuil de panique" var: panic_threshold min: 0.0 max: 1.0;
	parameter "Haut-parleurs actifs" var: speakers_active;
	parameter "Messages cellulaires envoyés" var: cellular_messages_sent;
	parameter "Nombre de policiers" var: nb_policemen min: 0 max: 20;

	output {
		file "batch_results.csv" {
			write "run,evacuated,panicked\n" + (run + "," + (nb_people - (person count(each.is_evacuated = false))) + "," + (person count(each.is_panicked = true)));
		}
	}
}

