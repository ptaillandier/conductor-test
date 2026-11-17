# Modèle GAMA : Simulation d'évacuation face à un Tsunami

Ce document décrit un modèle de simulation multi-agents (SMA) développé en GAML (GAMA Modeling Language) pour étudier l'évacuation d'une plage méditerranéenne en cas d'alerte tsunami. L'objectif est d'évaluer l'efficacité de différentes stratégies de gestion de crise.

## Objectif du modèle

L'objectif principal de ce modèle est d'aider les décideurs à choisir les meilleures stratégies d'évacuation en fonction des ressources disponibles et du niveau de risque. Il permet de simuler le comportement hétérogène de la population (résidents, touristes), l'impact des informations diffusées (haut-parleurs, messages cellulaires, policiers) sur leurs décisions d'évacuation et leur choix de destination (sorties, zone de sécurité).

## Entités et Espèces

Le modèle est composé des espèces d'agents suivantes :

*   **`person` (Personne) :** Représente les individus sur la plage. Ils peuvent être des résidents ou des touristes, avoir des connaissances différentes des sorties, et réagir à l'alerte de tsunami en tentant d'évacuer ou en paniquant.
    *   **Attributs :**
        *   `is_evacuated` (booléen) : Indique si la personne a atteint la zone de sécurité.
        *   `is_panicked` (booléen) : Indique si la personne est en état de panique.
        *   `is_resident` (booléen) : Indique si la personne est un résident (impact sur la réception d'informations).
        *   `knowledge_of_exit` (entier) : Index de la sortie que la personne connaît ou vers laquelle elle se dirige.
    *   **Comportements (`reflex`) :**
        *   `move_to_safety` : Décrit le mouvement des personnes vers les sorties et ensuite vers la colline. Le comportement varie selon si l'alerte a été donnée, si la personne panique, et les informations reçues (haut-parleurs, messages cellulaires, policiers).

*   **`policeman` (Policier) :** Représente les forces de l'ordre sur la plage. Leur rôle est de patrouiller et de guider les personnes en cas d'évacuation.
    *   **Comportements (`reflex`) :**
        *   `patrol` : Mouvement aléatoire des policiers sur la plage.
        *   `give_instructions` : Si une alerte est active, les policiers peuvent calmer les personnes en panique à proximité et leur indiquer la meilleure direction d'évacuation.

## Paramètres Globaux

Ces paramètres peuvent être ajustés dans l'interface graphique de l'expérimentation pour explorer différents scénarios :

*   `nb_people` (entier) : Nombre initial de personnes sur la plage (1000 par défaut).
*   `beach_width` (flottant) : Largeur de la plage en mètres (2000.0 par défaut).
*   `nb_exits` (entier) : Nombre de sorties disponibles sur la digue (4 par défaut).
*   `tsunami_warning_time` (flottant) : Temps d'alerte avant l'arrivée du tsunami en minutes (120.0 par défaut).
*   `evacuation_speed` (flottant) : Vitesse moyenne de déplacement des personnes en m/s (1.5 par défaut).
*   `panic_threshold` (flottant) : Probabilité qu'une personne panique (0.7 par défaut).
*   `speakers_active` (booléen) : Active ou désactive les haut-parleurs pour la diffusion d'informations (false par défaut).
*   `cellular_messages_sent` (booléen) : Active ou désactive l'envoi de messages cellulaires aux résidents (false par défaut).
*   `nb_policemen` (entier) : Nombre de policiers présents sur la plage (5 par défaut).

## Règles de Comportement

### `global`

*   **Initialisation :** Crée l'environnement (plage, colline, sorties) et initialise les populations de `person` et `policeman` avec des positions aléatoires. Les personnes sont désignées comme résidentes ou non avec une probabilité de 50%.
*   **`tsunami_alert` (reflex) :** Déclenche une alerte tsunami au premier cycle de la simulation, activant potentiellement les haut-parleurs et l'envoi de messages cellulaires.

### `person`

*   **`move_to_safety` (reflex) :**
    *   Si une alerte est active et la personne ne panique pas :
        *   Les résidents ayant reçu des messages cellulaires se dirigent vers la sortie la plus proche et ensuite vers la colline.
        *   Les personnes entendant les haut-parleurs se dirigent vers une sortie connue puis la colline.
        *   Sans information, les personnes choisissent une sortie aléatoirement et se dirigent vers la colline.
    *   Si une alerte est active et la personne panique : La personne se déplace aléatoirement à une vitesse réduite.
    *   Si la personne atteint la colline, elle est considérée comme évacuée et disparaît du modèle.
    *   Un seuil de panique peut être dépassé aléatoirement, faisant passer la personne en état de panique.

### `policeman`

*   **`patrol` (reflex) :** Les policiers se déplacent aléatoirement sur la plage.
*   **`give_instructions` (reflex) :** Si une alerte est active, les policiers interagissent avec les personnes à proximité pour calmer celles qui paniquent et leur fournir des informations sur les directions d'évacuation.

## Expérimentation `TsunamiEvacuation` (GUI)

Cette expérimentation offre une interface graphique pour visualiser la simulation et interagir avec ses paramètres.

*   **Paramètres ajustables :** Tous les paramètres globaux listés ci-dessus peuvent être modifiés via l'interface.
*   **Affichage graphique (`main_display`) :**
    *   **`person` :** Affichées comme des cercles. La couleur indique l'état :
        *   Bleu : Non évacué, non paniqué.
        *   Rouge : Paniqué.
        *   Vert : Évacué (et disparaît ensuite).
    *   **`policeman` :** Affichés comme des carrés jaunes.
    *   **`Plage` :** Zone orange.
    *   **`Colline` :** Zone verte (zone de sécurité).
    *   **`Sorties` :** Lignes noires sur la digue.
*   **Moniteurs :**
    *   "Personnes évacuées" : Affiche le nombre de personnes ayant atteint la colline.
    *   "Personnes en panique" : Affiche le nombre de personnes actuellement en état de panique.

## Instructions pour ouvrir le modèle dans GAMA Platform

1.  **Téléchargez et installez GAMA Platform :** Si ce n'est pas déjà fait, téléchargez la dernière version de GAMA depuis le site officiel (https://gama-platform.org/).
2.  **Lancez GAMA Platform.**
3.  **Importez le projet :**
    *   Allez dans `File > Import > General > Existing Projects into Workspace`.
    *   Sélectionnez `Select root directory` et naviguez jusqu'au dossier parent de ce dépôt (le dossier `irvine`).
    *   Assurez-vous que le projet `irvine` est coché dans la liste des projets détectés.
    *   Clique   z sur `Finish`.
4.  **Ouvrez le modèle :**
    *   Dans la vue `Navigator` (généralement à gauche), développez le projet `irvine`.
    *   Naviguez jusqu'à `models/mon_modele.gaml`.
    *   Double-cliquez sur `mon_modele.gaml` pour l'ouvrir dans l'éditeur GAML.
5.  **Lancez l'expérimentation :**
    *   Dans l'onglet `Outline` (généralement à droite de l'éditeur), développez `Experiment`.
    *   Double-cliquez sur l'expérimentation `TsunamiEvacuation`.
    *   Cliquez sur le bouton `Run` (icône de lecture verte) dans la barre d'outils de l'expérimentation.
    *   Vous pouvez alors ajuster les paramètres et observer la simulation dans l'interface graphique.
