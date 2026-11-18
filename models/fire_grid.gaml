/**
 * fire_grid.gaml
 *
 * Minimal forest-fire propagation model on a 20x20 grid.
 *
 * Each cell has a state among: "unburnt", "burning", "burnt".
 *
 * At every simulation step:
 *   1. Every burning cell tries to ignite each of its unburnt neighbours
 *      (Moore neighbourhood, i.e. the 8 surrounding cells) with probability
 *      `ignition_probability`.
 *   2. Every burning cell becomes "burnt".
 *   3. Cells ignited during step 1 become "burning".
 *
 * The simulation starts with a single random cell set on fire.
 *
 * The GUI experiment shows the grid and a chart tracking the number of cells
 * in each state over time.
 */

model fire_grid

global {
	// Probability for a burning cell to ignite one of its unburnt neighbours.
	float ignition_probability <- 0.35;

	// Size of the grid (grid_size x grid_size cells).
	int grid_size <- 20;

	// Side length (world units) of a single cell.
	float cell_size <- 1.0;

	// State labels used by the cells.
	string UNBURNT <- "unburnt";
	string BURNING <- "burning";
	string BURNT <- "burnt";

	// The world is a square of grid_size x grid_size units, so that with
	// cells of size cell_size we obtain exactly a grid_size x grid_size grid.
	geometry shape <- square(grid_size * cell_size);

	// ------------------------------------------------------------- init ----
	init {
		// Cells of a grid species are created automatically at init.
		// We only need to ignite one random cell.
		ask one_of(cell) {
			state <- BURNING;
		}
	}

	// ------------------------------------------------------- fire step -----
	// All the fire dynamics is done in a single reflex so that the three
	// phases below always happen in the intended order.
	reflex fire_spread {
		// Phase 1: collect the cells ignited by the currently burning cells.
		list<cell> newly_burning <- [];

		loop burning_cell over: cell where (each.state = BURNING) {
			loop n over: burning_cell.neighbors {
				if (n.state = UNBURNT and flip(ignition_probability)) {
					add n to: newly_burning;
				}
			}
		}

		// Phase 2: currently burning cells burn out.
		loop burning_cell over: cell where (each.state = BURNING) {
			burning_cell.state <- BURNT;
		}

		// Phase 3: newly ignited cells start burning.
		ask newly_burning {
			state <- BURNING;
		}
	}
}

/**
 * Grid species: GAMA automatically creates the 20x20 cells
 * (grid_size x grid_size) from the world dimensions and the cell size.
 */
grid cell width: cell_size height: cell_size {
	// Current state of the cell: UNBURNT, BURNING or BURNT.
	string state <- UNBURNT;

	// Colour matching the current state (used by the display).
	rgb get_color {
		if (state = BURNING) {
			return #red;
		}
		if (state = UNBURNT) {
			return #green;
		}
		return #black;
	}

	aspect default {
		draw shape color: get_color() border: #gray;
	}
}

// ------------------------------------------------------------ experiment ----

experiment "Fire Grid" type: gui {
	// The user can tune the ignition probability from the interface.
	parameter "Ignition probability" var: ignition_probability min: 0.0 max: 1.0;

	output {
		// Simple display of the grid: green = unburnt, red = burning,
		// black = burnt.
		display "Grid" {
			species cell aspect: default;
		}

		// Chart showing the number of cells in each state at every step.
		display "Evolution" type: 2d {
			chart "Cells per state" type: series {
				data "unburnt" value: length(cell where (each.state = UNBURNT)) color: #green;
				data "burning" value: length(cell where (each.state = BURNING)) color: #red;
				data "burnt" value: length(cell where (each.state = BURNT)) color: #black;
			}
		}
	}
}
