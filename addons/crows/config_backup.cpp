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
        units[] = {};
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

		function = "grad_crows_fnc_registerShot";	// Name of function triggered once conditions are met
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
};