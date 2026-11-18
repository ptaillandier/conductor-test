model dengue

global {
   // Number of human agents
   int nb_humans <- 20;
   // Number of mosquito agents
   int nb_mosquitoes <- 100;
   // Number of exits (or zones) influencing movement
   int nb_exits <- 3;
   // Infection parameters
   float infection_radius <- 2.0; // distance within which transmission can occur
   float prob_human_to_mosquito <- 0.4; // probability a mosquito gets infected when biting an infected human
   float prob_mosquito_to_human <- 0.6; // probability a human gets infected when bitten by an infected mosquito
}

experiment dengue type: gui {
   output {
      display dengue_display {
         // Visualisation of humans, mosquitoes and exits
      }
   }
   // Initialise the environment
   init {
      // Create human agents
      create humans number: nb_humans {
         string health <- "susceptible"; // possible values: susceptible, infected, recovered
         // Random initial position (placeholder)
         // location <- {rnd(100), rnd(100)};
         // Seed a few initial infected humans (e.g., 10% of the population)
         if (rnd(1) < 0.1) { health <- "infected"; }
      }
      // Create mosquito agents
      create mosquitos number: nb_mosquitoes {
         bool infected <- false;
         // Random initial position (placeholder)
         // location <- {rnd(100), rnd(100)};
      }
      // Create exits (or zones) – positions are placeholders
      create exits number: nb_exits {
         // location <- {0, rnd(100)};
      }
   }
   // Simple random movement for both humans and mosquitoes
   reflex move {
      // Placeholder for random walk or more realistic movement logic
   }
   // Transmission dynamics
   reflex transmission {
      // Mosquito bites humans: if a mosquito is near a susceptible human, infection may occur
      // and vice‑versa for infected humans infecting susceptible mosquitoes.
      // Actual implementation would require distance calculations between agents.
   }
}
