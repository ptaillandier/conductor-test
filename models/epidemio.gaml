model epidemio

global {
   // Number of agents
   int nb_agents <- 200;
   // Number of exits (could be zones influencing movement)
   int nb_exits <- 3;
   // Infection parameters
   float infection_radius <- 2.0; // distance within which infection can occur
   float infection_prob   <- 0.3; // probability of transmission per contact
}

experiment epidemic type: gui {
   output {
      display epidemic_display {
         // Visual representation of agents and exits
      }
   }
   // Initialise agents and exits
   init {
      // Create agents (persons) with health state
      create persons number: nb_agents {
         // possible health states: susceptible, infected, recovered
         string health <- "susceptible";
         // Random initial position (placeholder)
         // location <- {rnd(100), rnd(100)};
         // Seed a few initial infected agents
         if (rnd(1) < 0.05) { health <- "infected"; }
      }
      // Create exits (or zones)
      create exits number: nb_exits {
         // location <- {0, rnd(100)}; // placeholder
      }
   }
   // Movement rule: each person moves randomly (placeholder)
   reflex move {
      // Simple random walk; replace with realistic evacuation logic
   }
   // Infection propagation rule
   reflex infection {
      // For each infected person, infect susceptible neighbours within radius
      // Placeholder logic – actual implementation requires distance calculation
   }
}
