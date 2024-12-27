/*
[this, false, [0, 0, 0], 0] call ace_dragging_fnc_setDraggable;   
[this, false, [0, 0, 0], 0] call ace_dragging_fnc_setCarryable;   
clearMagazineCargo this;
clearWeaponCargo this;
clearItemCargoGlobal this;
this allowDamage false;
[this] execVM "arsenal\undercoverArsenalBox.sqf";
*/
sleep 2;
_undercoverGear = civUniforms + civHeadgear + civBackpacks + parseSimpleArray grad_civs_loadout_goggles;
_undercoverWeapons = [
	"Hate_Smartphone_HUD",
	"rhsusf_weap_MP7A2",
	"rhsusf_weap_MP7A2_desert",
	"rhsusf_acc_mrds",
	"rhsusf_acc_mrds_c",
	"rhsusf_acc_T1_low",
	"Tier1_MP7_LA5_M300C_Black",
	"rhsusf_acc_anpeq15side_bk",	
	"rhsusf_acc_rotex_mp7",
	"rhsusf_acc_rotex_mp7_desert",
	"rhsusf_acc_rvg_blk",
	"rhsusf_acc_tdstubby_blk",
	"rhsusf_acc_rvg_de",
	"rhsusf_acc_tdstubby_tan",
	"Tier1_DD_VFG_Black",
	"Tier1_DD_VFG_DE",
	"crow_x26_blk_yellow",
	"Tier1_Glock19_Urban_TB",
	"Tier1_Glock22_TB_Rail",
	"Tier1_P320_TB",
	"Tier1_P320_PMM",
	"Tier1_15Rnd_9x19_FMJ",
	"Tier1_15Rnd_9x19_JHP",
	"Tier1_20Rnd_9x19_FMJ",
	"Tier1_20Rnd_9x19_JHP",
	"Tier1_15Rnd_40SW_JHP",
	"Tier1_15Rnd_40SW_FMJ",
	"Tier1_20Rnd_40SW_JHP",
	"Tier1_20Rnd_40SW_FMJ",
	"Tier1_17Rnd_9x19_P320_FMJ",
	"Tier1_17Rnd_9x19_P320_JHP",
	"Tier1_21Rnd_9x19_P320_FMJ",
	"Tier1_21Rnd_9x19_P320_JHP",
	"rhsusf_mag_40Rnd_46x30_AP",
	"rhsusf_mag_40Rnd_46x30_FMJ",
	"rhsusf_mag_40Rnd_46x30_JHP",
	"rhsusf_m112_mag",
	"rhsusf_m112x4_mag",
	"ACE_Clacker",
	"ACE_wirecutter",
	"TM_Uni_I10",
	"TM_Uni_I5",
	"TM_Uni_I9",
	"TM_Uni_I3",
	"TM_Uni_I4",
	"TM_Uni_I12",
	"TM_Uni_I",
	"TM_Uni_I11",
	"TM_Uni_I2",
	"TM_Uni_I7",
	"TM_Uni_I8",
	"TM_Uni_I6"
];

_box = (_this select 0);

[_box, _undercoverGear + _undercoverWeapons, false] call ace_arsenal_fnc_initBox;