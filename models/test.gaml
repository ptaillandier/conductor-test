model test

global {
	// Number of dummy agents to create
	int nb_agents <- 10;
	
	init {
		create dummy number: nb_agents;
	}
}

species dummy {
	// Simple random position on the 100x100 grid
	point location <- {rnd(100), rnd(100)};
	
	aspect default {
		draw circle(2) color: #blue border: #black;
	}
}

experiment gui_experiment type: gui {
	output {
		display "dummy_display" {
			species dummy aspect: default;
		}
	}
}
