model evacuation_incendie

global {
   // Number of agents
   int nb_agents <- 200;
   // Number of exits
   int nb_exits <- 3;
}

experiment evacuation type: gui {
   output {
      display evacuation_display {
         // Visual representation of the building, agents, and exits
      }
   }
   // Create agents and exits at initialization
   init {
      // Create persons (agents) randomly inside the building
      create persons number: nb_agents {
         // position can be set randomly, e.g.,
         // location <- {rnd(100), rnd(100)}; // placeholder
      }
      // Create exits at predefined locations
      create exits number: nb_exits {
         // Define exit positions, e.g.,
         // location <- {0, rnd(100)}; // placeholder
      }
   }
   // Simple movement rule: each agent heads towards the nearest exit
   reflex move {
      // Find the nearest exit for each person and move towards it
      // This is a placeholder for actual path‑finding logic
   }
}
