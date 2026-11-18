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

Feel free to improve the model with realistic biting rates, incubation periods, or control strategies.
