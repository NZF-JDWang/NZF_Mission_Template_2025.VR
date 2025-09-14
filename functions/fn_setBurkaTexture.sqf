/*
 * Function: NZF_fnc_setBurkaTexture
 * 
 * Description:
 *     Sets a random texture for units wearing the U_C_Burka_2_Woman uniform.
 *     Removes headgear and goggles to ensure proper display of the burka texture.
 *     Uses a slight delay to ensure the unit is fully initialized before applying changes.
 *     Note: This function assumes the unit is already wearing the correct uniform.
 * 
 * Parameters:
 *     0: Unit <OBJECT> - The unit to apply the burka texture to
 * 
 * Returns:
 *     Nothing
 * 
 * Example:
 *     [player] call NZF_fnc_setBurkaTexture;
 * 
 * Author: NZF Mission Template
 * 
 * Dependencies:
 *     - CBA_fnc_waitAndExecute
 *     - HSim mod (for texture paths)
 */

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

    private _selectedTexture = selectRandom _burkaTextures;
    _unit setObjectTextureGlobal [0, _selectedTexture];
    removeHeadgear _unit;
    removeGoggles _unit;
}, [_unit], 0.1] call CBA_fnc_waitAndExecute; 