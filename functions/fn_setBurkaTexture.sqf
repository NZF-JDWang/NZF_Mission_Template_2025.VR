params ["_unit"];

[{
    params ["_unit"];
    
    private _burkaTextures = [
        "\HSim\Characters_H\Woman\Uniforms\data\tak_woman01_1_co.paa",
        "\HSim\Characters_H\Woman\Uniforms\data\tak_woman01_2_co.paa",
        "\HSim\Characters_H\Woman\Uniforms\data\tak_woman01_4_co.paa", 
        "\HSim\Characters_H\Woman\Uniforms\data\tak_woman01_3_co.paa",
        "\HSim\Characters_H\Woman\Uniforms\data\tak_woman01_5_co.paa"
    ];

    if (uniform _unit == "U_C_Burka_2_Woman") then {
        private _selectedTexture = selectRandom _burkaTextures;
        _unit setObjectTextureGlobal [0, _selectedTexture];
        removeHeadgear _unit;
        removeGoggles _unit;
    };
}, [_unit], 0.1] call CBA_fnc_waitAndExecute; 