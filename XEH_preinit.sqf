[
	"nzf_enableIntro",
	"CHECKBOX",
	["Enable Intro", "Toggle mission introduction sequence"],
	["[NZF] Mission Making", "1.Main"],
	false,
	1,
	{},
	false
] call CBA_Settings_fnc_init;

[
	"nzf_template_PJs",
	"EDITBOX",
	["Qualified PJ Steam UID's", "UID's for PJs"],
	["[NZF] Mission Making", "1.Main"],
	'["76561198060533591","76561198089268255","76561198215981868","76561198113862876"]',
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"nzf_template_defaultUniform",
	"EDITBOX",
	["Default Uniforms", "Classname of the uniforms you want people to spawn into"],
	["[NZF] Mission Making", "1.Main"],
	'["tfl_new_MC_fs_np_uniform"]',
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"nzf_template_Groups",
	"CHECKBOX",
	["Vanilla Group (U) Menu", "Turns on BI's dynamic group menu"],
	["[NZF] Mission Making", "1.Main"],
	[true],
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"nzf_template_unconsciousMumble",
	"CHECKBOX",
	["Unconscious Mumbling", "Stops players hearing voices when unconcious"],
	["[NZF] Mission Making", "1.Main"],
	[true],
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"nzf_template_trackerOn",
	"CHECKBOX",
	["Use the GPS tracker", "Enables GPS Tracking"],
	["[NZF] Mission Making", "2.GPS Tracking"],
	[true],
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"nzf_template_trackedObject",
	"EDITBOX",
	["Tracked Object", "Name of the object you are tracking"],
	["[NZF] Mission Making", "2.GPS Tracking"],
	["trackedObject"],
	1,
	{[nzf_template_trackedObject,true] call grad_gpsTracker_fnc_setTarget}
] call CBA_Settings_fnc_init;

[
	"nzf_template_tracker",
	"EDITBOX",
	["Tracker Object", "Needs to be in Players inventory for them to open the tracker"],
	["[NZF] Mission Making", "2.GPS Tracking"],
	["UMI_Land_Tablet_F"],
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"nzf_template_trackerRange",
	"SLIDER",
	["Tracker Range", "Range to get a signal"],
	["[NZF] Mission Making", "2.GPS Tracking"],
	[10, 2000, 50, 0, false],
	1,
	{}
] call CBA_Settings_fnc_init;
