module AstiLib

  # # Database
  # ----------
  # This module contains methods for creating database objects like: `Item`, `Weapon`, `Armor` and `Skill`.
  # Also contains variables and other objects needed for these methods.
  module Database

    #==============================================================================
    # Files that store the IDs of modded database objects
    #------------------------------------------------------------------------------
    # This is to prevent objects in mods from switching IDs when a user adds
    # or removes mods while playing on the same save file.
    #==============================================================================

    # The `actor_keys.dat` file that contains all actors added through AstiLib
    ACTOR_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "actor_keys.dat").freeze
    # The `class_keys.dat` file that contains all classes added through AstiLib
    CLASS_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "class_keys.dat").freeze
    # The `skill_keys.dat` file that contains all skills added through AstiLib
    SKILL_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "skill_keys.dat").freeze
    # The `item_keys.dat` file that contains all items added through AstiLib
    ITEM_KEYS_LIST      = File.join(AstiLib::ASTILIB_EXT_DIR, "item_keys.dat").freeze
    # The `weapon_keys.dat` file that contains all weapons added through AstiLib
    WEAPON_KEYS_LIST    = File.join(AstiLib::ASTILIB_EXT_DIR, "weapon_keys.dat").freeze
    # The `armor_keys.dat` file that contains all armors added through AstiLib
    ARMOR_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "armor_keys.dat").freeze
    # The `enemy_keys.dat` file that contains all enemies added through AstiLib
    ENEMY_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "enemy_keys.dat").freeze
    # The `troop_keys.dat` file that contains all troops added through AstiLib
    TROOP_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "troop_keys.dat").freeze
    # The `state_keys.dat` file that contains all states added through AstiLib
    STATE_KEYS_LIST     = File.join(AstiLib::ASTILIB_EXT_DIR, "state_keys.dat").freeze
    # The `animation_keys.dat` file that contains all animations added through AstiLib
    ANIMATION_KEYS_LIST = File.join(AstiLib::ASTILIB_EXT_DIR, "animation_keys.dat").freeze

    #==============================================================================
    # Symbols for system types
    #==============================================================================

    # ## Element Symbols
    # This contains symbols that can be used as an alternative to the element's ID.
    # In RPGMaker VX Ace 'Elements' can be found in the database under the tab 'Terms'.
    # *Everything aside from `normal_attack: -1` `none: 0` is game specific. More symbols can be added through `AstiLib::Database::ELEMENT_SYMBOLS.merge!()`.*
    # `normal_attack` can't be used in every case.
    ELEMENT_SYMBOLS = {
      normal_attack: -1,
      none: 0
    }

    # ## Skill Type Symbols
    # This contains symbols that can be used as an alternative to the skill type's ID.
    # In RPGMaker VX Ace 'Skill Types' can be found in the database under the tab 'Terms'.
    # *Everything aside from `none: 0` is game specific. More symbols can be added through `AstiLib::Database::SKILL_TYPE_SYMBOLS.merge!()`.*
    SKILL_TYPE_SYMBOLS = {
      none: 0
    }

    # ## Weapon Type Symbols
    # This contains symbols that can be used as an alternative to the weapon type's ID.
    # In RPGMaker VX Ace 'Weapon Types' can be found in the database under the tab 'Terms'.
    # *Everything aside from `none: 0` is game specific. More symbols can be added through `AstiLib::Database::WEAPON_TYPE_SYMBOLS.merge!()`.*
    WEAPON_TYPE_SYMBOLS = {
      none: 0
    }

    # ## Armor Type Symbols
    # This contains symbols that can be used as an alternative to the armor type's ID.
    # In RPGMaker VX Ace 'Armor Types' can be found in the database under the tab 'Terms'.
    # *Everything aside from `none: 0` is game specific. More symbols can be added through `AstiLib::Database::ARMOR_TYPE_SYMBOLS.merge!()`.*
    ARMOR_TYPE_SYMBOLS = {
      none: 0
    }

    # ## Equip Type Symbols
    # This contains symbols that can be used as an alternative to the equip type's ID.
    EQUIP_TYPE_SYMBOLS = {
      weapon: 0,
      shield: 1,
      head: 2,
      body: 3,
      accessory: 4
    }.freeze

    #==============================================================================
    # Symbols for parameters
    #==============================================================================

    # ## Parameter Symbols
    # This contains symbols for normal parameters, like: `MHP`, `ATK` and `LUK`, that can be used as an alternative to the parameter's ID.
    PARAM_SYMBOLS = {
      mhp: 0, max_hp: 0,        max_hit_points: 0,      max_health: 0,
      mmp: 1, max_mp: 1,        max_mana_points: 1,     max_mana: 1,
      atk: 2, attack: 2,        attack_power: 2,
      def: 3, defense: 3,       defense_power: 3,
      mat: 4, magic_attack: 4,  magic_attack_power: 4,
      mdf: 5, magic_defense: 5, magic_defense_power: 5,
      agi: 6, agility: 6,       spd: 6,                 speed: 6,
      luk: 7, luck: 7
    }.freeze

    # ## Extra Parameter Symbols
    # This contains symbols for extra parameters, like: `HIT`, `CRI` and `HRG`, that can be used as an alternative to the ex-parameter's ID.
    EX_PARAM_SYMBOLS = {
      hit: 0, hit_rate: 0,
      eva: 1, evasion_rate: 1,
      cri: 2, critical_rate: 2,
      cev: 3, critical_evasion_rate: 3,
      mev: 4, magic_evasion_rate: 4,
      mrf: 5, magic_reflection_rate: 5,
      cnt: 6, counter_attack_rate: 6,
      hrg: 7, hp_regen_rate: 7,
      mrg: 8, mp_regen_rate: 8,
      trg: 9, tp_regen_rate: 9
    }.freeze

    # ## Special Parameter Symbols
    # This contains symbols for special parameters, like: `TRG`, `GRD` and `EXR`, that can be used as an alternative to the sp-parameter's ID.
    SP_PARAM_SYMBOLS = {
      trg: 0, target_rate: 0,
      grd: 1, guard_effect_rate: 1,
      rec: 2, recovery_effect_rate: 2,
      pha: 3, pharmacology: 3,
      mcr: 4, mp_cost_rate: 4,
      tcr: 5, tp_charge_rate: 5,
      pdr: 6, physical_damage_rate: 6,
      mdr: 7, magical_damage_rate: 7,
      fdr: 8, floor_damage_rate: 8,
      exr: 9, experience_rate: 9
    }.freeze

    #==============================================================================
    # Symbols for "other" features
    #==============================================================================

    # ## Special Flag Type Symbols
    # This contains symbols for special flag types that can be used as an alternative to the special flag type's ID.
    SPECIAL_FLAG_TYPE_SYMBOLS = {
      auto_battle: 0,
      guard: 1,
      substitute: 2,
      preserve_tp: 3
    }.freeze

    # ## Collapse Effect Type Symbols
    # This contains symbols for collapse effect types that can be used as an alternative to the collapse effect type's ID.
    COLLAPSE_EFFECT_TYPE_SYMBOLS = {
      normal: 0,
      boss: 1,
      instant: 2,
      not_disappear: 3
    }.freeze

    # ## Party Ability Type Symbols
    # This contains symbols for party ability types that can be used as an alternative to the party ability type's ID.
    PARTY_ABILITY_TYPE_SYMBOLS = {
      encounter_half: 0,
      encounter_none: 1,
      cancel_suprise: 2,
      raise_preemtive: 3,
      gold_double: 4,
      item_double: 5, drop_item_double: 5
    }.freeze

    #==============================================================================
    # Symbols for attributes
    #==============================================================================
    SCOPE_SYMBOLS = {
      none: 0,
      one_enemy: 1,
      all_enemies: 2,
      one_random_enemy: 3,
      two_random_enemies: 4,
      three_random_enemies: 5,
      four_random_enemies: 6,
      one_ally: 7,
      all_allies: 8,
      one_ally_dead: 9, one_dead_ally: 9,
      all_allies_dead: 10, all_dead_allies: 10,
      the_user: 11, user: 11, self: 11
    }.freeze

    OCCASION_SYMBOLS = {
      always: 0,
      only_in_battle: 1, battle_only: 1,
      only_from_the_menu: 2, menu_only: 2,
      never: 3
    }.freeze

    # ## Hit Type Symbols
    # This contains symbols that can be used as an alternative to the hit type's ID.
    HIT_TYPE_SYMBOLS = {
      certain_hit: 0,     certain: 0,
      physical_attack: 1, physical: 1,
      magical_attack: 2,  magical: 2
    }.freeze

    DAMAGE_TYPE_SYMBOLS = {
      none: 0,
      hp_damage: 1,
      mp_damage: 2,
      hp_recover: 3,
      mp_recover: 4,
      hp_drain: 5,
      mp_drain: 6
    }.freeze

    ITEM_TYPE_SYMBOLS = {
      normal: 1,
      key_item: 2
    }
  end
end