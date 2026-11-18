# GAMA Models Repository

This repository contains GAMA models for various simulations.

## evacuation_incendie.gaml

**Purpose**: Simulate the evacuation of a building during a fire.

**Features**:
- 200 agents representing occupants.
- 3 exits defined in the environment.
- Simple movement rule where each agent heads toward the nearest exit.
- GUI experiment (`evacuation`) to visualise the process.

**How to run**:
1. Open GAMA.
2. Load the model `models/evacuation_incendie.gaml`.
3. Run the `evacuation` experiment.

Feel free to modify the model to incorporate more realistic behaviours, obstacles, or evacuation strategies.

## epidemio.gaml

**Purpose**: Simulate the propagation of an infectious disease among moving agents.

**Features**:
- 200 agents moving within the environment.
- 3 exits (or zones) influencing movement.
- Simple infection dynamics: agents become infected upon contact with infected agents.
- GUI experiment (`epidemic`) to visualize spread.

**How to run**:
1. Open GAMA.
2. Load the model `models/epidemio.gaml`.
3. Run the `epidemic` experiment.

Feel free to extend the model with more realistic transmission parameters, recovery, or mitigation measures.

## dengue.gaml

**Purpose**: Simulate the propagation of dengue fever between humans and mosquitoes.

**Features**:
- 20 human agents moving in the environment.
- 100 mosquito agents acting as vectors.
- 3 exits (or zones) that influence movement.
- Basic infection dynamics: mosquitoes can infect humans and vice‑versa when they are within a given radius.
- GUI experiment (`dengue`) to visualise the spread.

**How to run**:
1. Open GAMA.
2. Load the model `models/dengue.gaml`.
3. Run the `dengue` experiment.

Feel feel to improve the model with realistic biting rates, incubation periods, or control strategies.

## fire_grid.gaml

**Purpose**: Simulate the propagation of a fire on a 20 × 20 cellular grid.

**Features**:
- 400 cells (20 × 20) each with a state: *unburnt*, *burning*, *burnt*.
- Burning cells may ignite neighboring unburnt cells with a configurable probability.
- GUI experiment (`Fire Grid`) displays the grid (green/unburnt, red/burning, black/burnt) and a chart tracking the number of cells in each state over time.
- Parameter to adjust the ignition probability from the interface.

**How to run**:
1. Open GAMA.
2. Load the model `models/fire_grid.gaml`.
3. Run the `Fire Grid` experiment.

Feel free to extend the model (e.g., wind influence, different neighbourhoods, fuel loads, etc.).

## test.gaml

**Purpose**: Simple demonstration model that creates 10 dummy agents displayed as blue circles.

**Features**:
- 10 `dummy` agents positioned randomly.
- Each agent is rendered as a circle (radius 2) with blue fill and black border.
- GUI experiment `gui_experiment` shows the agents in a display.

**How to run**:
1. Open GAMA.
2. Load the model `models/test.gaml`.
3. Run the `gui_experiment` experiment.

Feel free to extend this model with movement, interactions, or more complex visualisation.

## trafic.gaml

**Purpose**: Simulate road traffic on a single road segment.

**Features**:
- 10 car agents moving along the road.
- 2 exits (or endpoints) influencing vehicle flow.
- Simple car-following behavior placeholder.
- GUI experiment (`traffic`) to visualise vehicle movement.

**How to run**:
1. Open GAMA.
2. Load the model `models/trafic.gaml`.
3. Run the `traffic` experiment.

Feel free to enhance the model with realistic acceleration, lane‑changing, traffic lights, or congestion dynamics.
