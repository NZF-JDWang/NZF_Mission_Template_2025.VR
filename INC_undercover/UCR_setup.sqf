/*

Setup options for INC_undercover undercover / civilian recruitment script by Incontinentia.

Please check each setting carefully otherwise the script may not function properly in your scenario. All classnames must have quotation marks ("Item_Random_F")

*/

//-------------------------Player settings-------------------------

_undercoverUnitSide = west;             //What side is/are the undercover unit(s) on? (Can be east, west or independent - only one side supported)

//-------------------------General Settings-------------------------

_debug = false;                         //Set to true for debug
_fullAIfunctionality = true;            //Enable all checks on AI (may degrade performace very slightly for large groups, 15+)
_easyMode = true;                       //Disguise checks will also reveal if the player's disguise is working or not

_racism = false;                         //Enemies will notice if you aren't the race of the faction you're pretending to be (making you easier to detect if nothing is covering your face)
_racProfFacCiv = 1;                     //(Number) Multiplies the effect of racial profiling. Lower this number to simulate more multicultural civilian population
_racProfFacEny = 1;                     //(Number) Multiplies the effect of racial profiling. Lower this number to simulate more multicultural enemy forces

_regEnySide = east;                     //Units of this side will be classed as regular enemies and will share information about detected units across entire map (Side: can be east, west, independent) - if you don't need this, use sideEmpty.
_regBarbaric = false;                   //(Bool - true or false) Will this side lash out on civilians if it takes casualties and doesn't know the attacker?
_regDetectRadius = 7;                  //Default detection radius for regular troops (this will expand and contract based on weather, time of day, and how the undercover unit is acting - civilians within this radius will be under much more scrutinty)

_asymEnySide = sideEmpty;               //Units of this side will be classed as asymetric enemies (Side: can be east, west, independent) - if you don't need this, use sideEmpty.
_asymBarbaric = false;                   //(Bool - true or false) Will this side have a small chance of lashing out on civilians if it takes casualties and doesn't know the attacker?
_asymDetectRadius = 7;                 //Default detection radius for asym troops (this will expand and contract based on weather, time of day, and how the undercover unit is acting - civilians within this radius will be under much more scrutinty)

_globalSuspicionModifier = 2;           //Scales the level of suspicion of enemies. 1 is default, 2 means units are twice as likely to see through undercover unit's disguises, 0.5 means half as likely etc.

_HMDallowed = false; 					//(Bool - true or false) Are HMDs (night vision goggles etc.) safe to wear for units pretending to be civilians? Set to false if wearing HMDs will cause suspicion (must be stored in backpack).
_noOffRoad = false; 					//Civilian vehicles driving at speed more than 50 meters from the nearest road will immediately be considered hostile (even if false, this will be seen as suspicious)

//-------------------------Pull in civilian gear from grad_civs-------------------------
_grad_civs_Uniforms = parseSimpleArray grad_civs_loadout_clothes;
_grad_civs_Uniforms = _grad_civs_Uniforms select { 
    _x != "" && !(isNil "_x")
};

_grad_civs_HeadGear = parseSimpleArray grad_civs_loadout_headgear;
_grad_civs_HeadGear = _grad_civs_HeadGear select { 
    _x != "" && !(isNil "_x")
};

_grad_civs_Backpacks = parseSimpleArray grad_civs_loadout_backpacks;
_grad_civs_Backpacks = _grad_civs_Backpacks select { 
    _x != "" && !(isNil "_x")
};

_grad_civs_Vehicles = parseSimpleArray grad_civs_cars_vehicles;
_grad_civs_Vehicles = _grad_civs_Vehicles select { 
    _x != "" && !(isNil "_x")
};
//---------------------Civilian Disguise settings---------------------
//-------------------------EDIT THIS SECTION--------------------------

//Civilian faction
_civFactions = []; 

//(Array of classnames) Safe vests (on top of the specific factions above - useful if faction has randomisation script or to add items that are not used by the faction)
_civilianVests = [];

//(Array of classnames) Safe uniforms (on top of the specific factions above - useful if faction has randomisation script or to add items that are not used by the faction)

_civilianUniforms = _grad_civs_Uniforms + [];
civUniforms = _civilianUniforms;
//(Array of classnames) Safe headgear (will automatically include civilian headgear classes - useful if faction has randomisation script or to add items that are not used by the faction)

_civilianHeadgear = _grad_civs_HeadGear + [];
civHeadgear = _civilianHeadgear;
//(Array of classnames) Safe backpacks (will automatically include civilian backpack classes - useful if faction has randomisation script or to add items that are not used by the faction)

_civilianBackpacks = _grad_civs_Backpacks + [];
civBackpacks = _civilianBackpacks;	
//(Array of classnames) Safe vehicles to drive in (automatically includes vehicles from the civilian factions above).

_civilianVehicleArray = _grad_civs_Vehicles + [];


//-------------------------------------------------------------------------
//-------------------------Enemy Disguise settings-------------------------
_incogFactions = []; //Array of enemy factions whose items and vehicles will allow the player to impersonate the enemy

 //Names of additional markers for areas that would be considered trespassing (any with "INC_tre" - case sensitive - somewhere in the marker name will automatically be included)
_trespassMarkers = [];

//(Array of classnames) Safe vests (on top of the specific factions above - useful if faction has randomisation script or to add items that are not used by the faction)
_incognitoVests = [];

//(Array of classnames) Safe headgear (will automatically include incog headgear classes - useful if faction has randomisation script or to add items that are not used by the faction)
_incognitoHeadgear = [];

//(Array of classnames) Safe backpacks (will automatically include incog backpack classes - useful if faction has randomisation script or to add items that are not used by the faction)
_incognitoBackpacks = [];

//(Array of classnames) Safe uniforms (on top of the specific factions above - useful if faction has randomisation script or to add items that are not used by the faction)
_incognitoUniforms = [];

_incogVehArray = []; //(Array of classnames) Additional incognito vehicles (vehicles from the faction above will automatically count, as will all _highSecVehicles)



//-------------------------High security zone settings-------------------------
/*
High security zones are areas that can only be entered with specific uniforms / items, even if the unit is disguised as an enemy.
For instance, it could be a radar installation or a marker in the vicinity of a high value target that only specially designated units are allowed near.
All high security zones are automatically considered non-civilian territory, but units dressed as enemies can enter without being instantly considered hostile, but they will attract a LOT more attention.
In these settings, you can .
*/

_highSecMarkers = []; 					//Names of additional markers for areas that are designated high security zones that require specific uniforms to enter without raising suspicion (any with "INC_highSec" - case sensitive - somewhere in the marker name will automatically be included)

_highSecInstantHostile = false;         // If true, units entering high security areas with the wrong uniform will be instantly deemed hostile by enemy forces. If false, it will be highly suspicious.

_highSecVehicles = [];                  // (Array of classnames) Vehicles that can enter high security areas without raising suspicion (uniforms will still be noticed according to how open the vehicle is)

_highSecurityUniforms = [];             // (Array of classnames) Uniforms that allow entry into high security areas (defined by high security markers)

_highSecItemCheck = true;               // Check for disallowed items that aren't in the permitted list? Each non-permitted item will incur a suspicion penality. Set to false if high security checks just include uniform only.

_highSecItems = [];                     // (Array of classnames) List of items such as vests, headgear, hats etc., that won't cause suspicion in high security areas (only works on foot for now)

_hsItChkOutside = true;                 // The high security item check will occur if wearing a high security uniform even in non-high security zones. Useful if the high security uniform is, for example, a businessman or scientist, who would look weird carrying a gun and helmet.

_hsMustBeUnarmed = true;               // Units carrying weapons will be considered hostile (requires _highSecItemCheck to be set to true).

_highSecItemCheckScalar = 1;            // Multiplies the level of suspicion caused by each suspect item when in a high security zone


//-------------------------Civilian recruitment settings-------------------------
/*
By enabling civilian recruitment, undercover can recruit any ambient civilians they see into their group (if their reputation allows / the civvy wants to join).
Civilians will operate under similar restrictions to the player.
You can also dismiss your new teammates and they will leave your group and carry on doing whatever it is they fancy doing (usually sitting cross-legged in the middle of a field).
*/

_civRecruitEnabled = false;          //(Bool - true or false) Set this to false to prevent undercover units from recruiting civilians
_armedCivPercentage = 70;           //(Number - 0 to 100) Max percentage of civilians armed with weapons from the array below, either on their person or in their backpacks (will only work if _civRecruitEnabled is set to true, otherwise this is ignored)

//Weapon classnames for armed civilians (array of classnames)
_civWpnArray = [];

//Items that civilians may carry
_civItemArray = [];

//Civilian backpack classes (array of classnames)
_civPackArray = [];
