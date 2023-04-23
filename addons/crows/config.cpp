// All addons must have this class
class CfgPatches
{
    class grad_crows
    {
        // Meta information for editor
        name = "Grad Crows";
        author = "nomisum";
        url = "https://www.gruppe-adler.de";

        // Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game. Note: was disabled on purpose some time late into Arma 2: OA.
        requiredVersion = 2.10;
        // Required addons, used for setting load order.
        // When any of the addons is missing, pop-up warning will appear when launching the game.
        requiredAddons[] = { "A3_Functions_F" };
        // List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups) unlocking.
        units[] = {"Grad_Crow"};
        // List of weapons (CfgWeapons classes) contained in the addon.
        weapons[] = {};
    };
};

#include "cfgFunctions.hpp"
#include "cfgSounds.hpp"

class CfgFactionClasses
{
	class NO_CATEGORY;
	class grad_crows: NO_CATEGORY
	{
		displayName = "Sa'hatra Crows";
	};
};

class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e. text input field)
			class Combo;				// Default combo box (i.e. drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};

		// Description base classes (for more information see below):
		class ModuleDescription
		{
			class AnyStaticObject;
		};
	};

	class grad_crows_count: Module_F
	{
		// Standard object definitions:
		scope = 2;										// Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "Crows Count";				// Name displayed in the menu
		icon = "\crows\data\gruppe-adler.paa";	// Map icon. Delete this entry to use the default icon.
		category = "Ambient";

		function = "";	// Name of function triggered once conditions are met
		functionPriority = 1;				// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 1;						// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;				// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation won't work)
		is3DEN = 0;							// 1 to run init function in Eden Editor as well
		curatorInfoType = "RscDisplayAttributeModuleNuke"; // Menu displayed when the module is placed or double-clicked on by Zeus

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes: AttributesBase
		{

			// Module-specific arguments:
			class count: Combo
			{
				property = "grad_crows_count";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Crows count";			// Argument label
				tooltip = "How many crows are there";	// Tooltip description
				typeName = "NUMBER";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "50";							// Default attribute value. Warning: This is an expression, and its returned value will be used (50 in this case).

				// Listbox items:
				class Values
				{
					class 50Mt	{ name = "50 crows";	value = 50; };
					class 100Mt	{ name = "100 crows"; value = 100; };
				};
			};

			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description (must inherit from base class, otherwise pre-defined entities won't be available):
		class ModuleDescription: ModuleDescription
		{
			description = "Short module description";	// Short description, will be formatted as structured text
			sync[] = {"LocationArea_F"};				// Array of synced entities (can contain base classes)

			class LocationArea_F
			{
				description[] = { // Multi-line descriptions are supported
					"Place on map where crows should spawn",
					"Optionally sync with static objects that crows should spawn on"
				};
				position = 1;	// Position is taken into effect
				direction = 1;	// Direction is taken into effect
				optional = 1;	// Synced entity is optional
				duplicate = 1;	// Multiple entities of this type can be synced
				synced[] = {"AnyStaticObject"}; // Pre-defined entities like "AnyBrain" can be used (see the table below)
			};
		};
	};

	class Animal_Base_F;
    class grad_crowe_base: Animal_Base_F
    {
        author = "nomisum";
        _generalMacro = "grad_crowe_base";
        class EventHandlers;
        class Wounds
        {
            tex[] = {};
            mat[] = {};
        };
        class VariablesScalar
        {
            _threatMaxRadius = 5;
            _runDistanceMax = 30;
            _movePrefer = 0.8;
            _formationPrefer = 0.5;
            _scareLimit = 0.2;
            _dangerLimit = 1.0;
            _walkSpeed = 0.31;
        };
        class VariablesString
        {
            _expSafe = "(1 - trees) * (1 - forest) * (houses) * (1 - sea)";
            _expDanger = "(1 - trees) * (1 - forest) * (houses) * (1 - sea)";
        };
    };
    class grad_crowe: grad_crowe_base
    {
        author = "nomisum";
        _generalMacro = "grad_crowe";
        scope = 1;
        displayName = "Crowe (Global Entity)";
        model = "\A3\Animals_F\Seagull\Crowe.p3d";
        moves = "CfgMovesGradCrowe";
        class Wounds: Wounds
        {
            mat[] = {"A3\animals_f_beta\chicken\data\hen.rvmat","A3\animals_f_beta\chicken\data\W1_hen.rvmat","A3\animals_f_beta\chicken\data\W2_hen.rvmat"};
        };
    };
};

class CfgMovesAnimal_Base_F {
	class Default;
	class StandBase;
	class DefaultDie;
	class States;
	class Actions {
		class NoActions;
	};
	class BlendAnims;
};

class CfgMovesGradCrowe: CfgMovesAnimal_Base_F
	{
		access = 1;
		skeletonName = "BirdSkeleton";
		collisionVertexPattern[] = {"1a", "2a", "3a", "4a", "5a", "6a", "7a", "8a", "9a", "10a", "11a", "12a", "13a", "14a", "15a", "16a", "17a", "18a", "19a", "20a", "21a", "22a", "23a", "24a", "25a", "26a", "27a", "28a", "29a", "30a", "31a", "32a", "33a", "34a"};
		collisionGeomCompPattern[] = {1};
		class Default: Default
		{
			collisionShape = "A3\animals_f\Rabbit\Rabbit_CollShape.p3d";
			actions = "GradCroweActions";
		};
		class StandBase: Default
		{
			actions = "GradCroweActions";
			aiming = "aimingDefault";
			leaningFactorBeg = 1;
			leaningFactorEnd = 1;
			disableWeapons = 1;
			disableWeaponsLong = 1;
		};
		class DefaultDie: Default
		{
			aiming = "aimingNo";
			legs = "legsNo";
			head = "headNo";
			disableWeapons = 1;
			interpolationRestart = 1;
			soundEdge1 = 0.45;
			soundEdge2 = 0.45;
		};
		class States
		{
			class grad_crowe_idle: StandBase
			{
				actions = "GradCroweActions";
				file = "\A3\animals_f\data\anim\flying.rtm";
				looped = 1;
				speed = -11;
				walkcycles = 1;
				variantsAI[] = {"grad_crowe_idle", 0.3, "grad_crowe_idleAlt", 0.3, "grad_crowe_flySlow", 0.4};
				connectTo[] = {"grad_crowe_idle", 0.02, "grad_crowe_idleAlt", 0.02};
				interpolateTo[] = {"grad_crowe_flySlow", 0.1, "grad_crowe_stop", 0.5, "grad_crowe_die", 0.1};
				preload = 1;
			};
			class grad_crowe_idleAlt: grad_crowe_idle
			{
				file = "\A3\animals_f\data\anim\land.rtm";
				looped = 0;
				speed = -1;
			};
			class grad_crowe_flySlow: StandBase
			{
				file = "\A3\animals_f\data\anim\flying.rtm";
				looped = 1;
				speed = -3;
				connectFrom[] = {"grad_crowe_flyDefault", 0.1, "grad_crowe_idle", 0.1};
				connectTo[] = {"grad_crowe_flyDefault", 0.1, "grad_crowe_idle", 0.1};
				interpolateTo[] = {"grad_crowe_die", 0.1};
			};
			class grad_crowe_flyDefault: StandBase
			{
				file = "\A3\animals_f\data\anim\flying.rtm";
				looped = 1;
				relSpeedMin = 0.5;
				relSpeedMax = 1;
				speed = -0.6;
				connectFrom[] = {"grad_crowe_flyFast", 0.2, "grad_crowe_flySlow", 0.1};
				connectTo[] = {"grad_crowe_flyFast", 0.2, "grad_crowe_flySlow", 0.1};
				interpolateTo[] = {"grad_crowe_die", 0.1};
			};
			class grad_crowe_flyFast: StandBase
			{
				file = "\A3\animals_f\data\anim\flying.rtm";
				looped = 1;
				speed = 5;
				connectTo[] = {"grad_crowe_flyFast", 0.1, "grad_crowe_flyDefault", 0.2};
				interpolateTo[] = {"grad_crowe_die", 0.1};
			};
			class grad_crowe_die: DefaultDie
			{
				actions = "NoActions";
				file = "\A3\animals_f\data\anim\land.rtm";
				looped = 1;
				speed = 2;
				variantsPlayer[] = {};
				variantsAI[] = {"grad_crowe_die", 0.5, "grad_crowe_die3", 0.5};
				variantAfter[] = {0, 0, 0};
			};
			class grad_crowe_die3: grad_crowe_die
			{
				looped = 1;
				speed = 3;
				file = "\A3\animals_f\data\anim\land.rtm";
			};
			class grad_crowe_stop: grad_crowe_idle
			{
				actions = "GradCroweForceStop";
				connectTo[] = {"grad_crowe_stop", 0.02};
				interpolateTo[] = {"grad_crowe_idle", 0.02, "grad_crowe_die", 0.02};
			};
		};
		class Actions: Actions
		{
			class NoActions: NoActions
			{
				turnSpeed = 15;
				limitFast = 5.5;
				useFastMove = 0;
				upDegree = 0;
			};
			class GradCroweActions: NoActions
			{
				Stop = "grad_crowe_idle";
				StopRelaxed = "grad_crowe_idle";
				TurnL = "grad_crowe_idle";
				TurnR = "grad_crowe_idle";
				TurnLRelaxed = "grad_crowe_idle";
				TurnRRelaxed = "grad_crowe_idle";
				Default = "grad_crowe_idle";
				JumpOff = "grad_crowe_idle";
				WalkF = "grad_crowe_flySlow";
				SlowF = "grad_crowe_flyFast";
				FastF = "grad_crowe_flyFast";
				EvasiveForward = "grad_crowe_flyFast";
				Down = "grad_crowe_idle";
				Up = "grad_crowe_idle";
				PlayerStand = "grad_crowe_idle";
				PlayerCrouch = "grad_crowe_idle";
				PlayerProne = "grad_crowe_idle";
				Lying = "grad_crowe_idle";
				Stand = "grad_crowe_idle";
				Combat = "grad_crowe_idle";
				Crouch = "grad_crowe_idle";
				CanNotMove = "grad_crowe_idle";
				Civil = "grad_crowe_idle";
				CivilLying = "grad_crowe_idle";
				FireNotPossible = "grad_crowe_idle";
				Die = "grad_crowe_die";
				LookAround = "";
				turnSpeed = 300;
				limitFast = 5.5;
				useFastMove = 0;
				upDegree = "ManPosNoWeapon";
			};
			class GradCroweForceStop: GradCroweActions
			{
				CivilLying = "grad_crowe_idle";
			};
			class GradCroweForceHop: GradCroweActions
			{
				CivilLying = "grad_crowe_idle";
			};
		};
		class Interpolations
		{
		};
		transitionsInterpolated[] = {};
		transitionsSimple[] = {};
		transitionsDisabled[] = {};
		class BlendAnims: BlendAnims
		{
			aimingDefault[] = {"head", 1, "leftEar", 1, "rightEar", 1};
			untiltWeaponDefault[] = {};
			legsDefault[] = {};
			headDefault[] = {};
			aimingNo[] = {};
			legsNo[] = {};
			headNo[] = {};
			aimingUpDefault[] = {};
		};
};