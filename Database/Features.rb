module AstiLib; module Database

  # # Features
  # ----------
  # This module has methods for adding `RPG::BaseItem::Feature`s to
  # items like weapons and armor. But also actors and classes.
  module Features

    # # Rate Features
    # ---------------
    # Methods for adding features from the 'Rate' tab.
    module RateFeatures

      # Changes the damage multiplier according to the specified
      # element. The higher the value, the greater the weakness
      # against the element.
      # 
      # @param [Integer] element_id The ID of the element you want to add resistance/weakness to. Can also be a symbol in `AstiLib::Database::ELEMENT_SYMBOLS`
      # @param [Float] percent
      # @return [Nil]
      def add_element_rate(element_id, percent)
        element_id = element_id.is_a?(Symbol) ? AstiLib::Database::ELEMENT_SYMBOLS[element_id] : element_id
        raise "Invalid element" unless element_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_ELEMENT_RATE, element_id, percent / 100.0))
      end
    
      # Changes the probability at which the use of a skill or item will
      # succeed in debuffing a parameter.
      # 
      # @param [Integer] param_id The ID of the parameter you want to make easier/harder to debuff. Can also be a symbol in `AstiLib::Database::PARAM_SYMBOLS`
      # @param [Float] percent
      # @return [Nil]
      def add_debuff_rate(param_id, percent)
        param_id = param_id.is_a?(Symbol) ? AstiLib::Database::PARAM_SYMBOLS[param_id] : param_id
        raise "Invalid stat" unless param_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_DEBUFF_RATE, param_id, percent / 100.0))
      end
    
      # Changes the probability at which the use of a skill or item will
      # succeed in applying a state.
      # 
      # @param [Integer] state_id The ID of the state you want to add resistance/weakness to.
      # @param [Float] percent
      # @return [Nil]
      def add_state_rate(state_id, percent)
        state_id = state_id.is_a?(Symbol) ? $data_states.find { |state| state.name.to_sym == state_id }.id : state_id
        raise "Invalid state" unless state_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_STATE_RATE, state_id, percent / 100.0))
      end
    
      # Completely negates a state. If knockouts are negated,
      # characters will not be knocked out even when their HP falls to
      # 0.
      # 
      # @param [Integer] state_id The ID of the state you want to resist.
      # @return [Nil]
      def add_state_resist(state_id)
        state_id = state_id.is_a?(Symbol) ? $data_states.find { |state| state.name.to_sym == state_id }.id : state_id
        raise "Invalid state" unless state_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_STATE_RESIST, state_id, 0))
      end
    end

    # # Parameter Features
    # --------------------
    # Methods for adding features from the 'Parameter' tab.
    module ParameterFeatures
      def add_parameter(param_id, percent)
        param_id = param_id.is_a?(Symbol) ? AstiLib::Database::PARAM_SYMBOLS[param_id] : param_id
        raise "Invalid parameter" unless param_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_PARAM, param_id, percent / 100.0))
      end
    
      def add_ex_parameter(ex_param_id, percent)
        ex_param_id = ex_param_id.is_a?(Symbol) ? AstiLib::Database::EX_PARAM_SYMBOLS[ex_param_id] : ex_param_id
        raise "Invalid ex-parameter" unless ex_param_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_XPARAM, ex_param_id, percent / 100.0))
      end
    
      def add_sp_parameter(sp_param_id, percent)
        sp_param_id = sp_param_id.is_a?(Symbol) ? AstiLib::Database::SP_PARAM_SYMBOLS[sp_param_id] : sp_param_id
        raise "Invalid sp-parameter" unless sp_param_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_SPARAM, sp_param_id, percent / 100.0))
      end
    end

    # # Attack Features
    # -----------------
    # Methods for adding features from the 'Attack' tab.
    module AttackFeatures
      def add_attack_element(element_id)
        element_id = element_id.is_a?(Symbol) ? AstiLib::Database::ELEMENT_SYMBOLS[element_id] : element_id
        raise "Invalid element" unless element_id
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_ATK_ELEMENT, element_id, 0))
      end
    
      def add_attack_state(state_id, percent)
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_ATK_STATE, state_id, percent / 100.0))
      end
    
      def add_attack_speed(amount)
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_ATK_SPEED, 0, amount))
      end
    
      def add_attack_times(amount)
        self.features.push(RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_ATK_TIMES, 0, amount))
      end
    end

    # # Skill Features
    # ----------------
    # Methods for adding features from the 'Skill' tab.
    module SkillFeatures
      def add_skill_type(skill_type_id)
        skill_type_id = skill_type_id.is_a?(Symbol) ? AstiLib::Database::SKILL_TYPE_SYMBOLS[skill_type_id] : skill_type_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_STYPE_ADD, skill_type_id)
        @features.push(feature)
      end

      def seal_skill_type(skill_type_id)
        skill_type_id = skill_type_id.is_a?(Symbol) ? AstiLib::Database::SKILL_TYPE_SYMBOLS[skill_type_id] : skill_type_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_STYPE_SEAL, skill_type_id)
        @features.push(feature)
      end

      def add_skill(skill_id)
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_SKILL_ADD, skill_id)
        @features.push(feature)
      end

      def seal_skill(skill_id)
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_SKILL_SEAL, skill_id)
        @features.push(feature)
      end
    end

    # # Equip Features
    # ----------------
    # Methods for adding features from the 'Equip' tab.
    module EquipFeatures
      def add_equip_weapon(weapon_type_id)
        weapon_type_id = weapon_type_id.is_a?(Symbol) ? AstiLib::Database::WEAPON_TYPE_SYMBOLS[weapon_type_id] : weapon_type_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_EQUIP_WTYPE, weapon_type_id)
        @features.push(feature)
      end

      def add_equip_armor(armor_type_id)
        armor_type_id = armor_type_id.is_a?(Symbol) ? AstiLib::Database::ARMOR_TYPE_SYMBOLS[armor_type_id] : armor_type_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_EQUIP_ATYPE, armor_type_id)
        @features.push(feature)
      end

      def fix_equip(equip_type_id)
        equip_type_id = equip_type_id.is_a?(Symbol) ? AstiLib::Database::EQUIP_TYPE_SYMBOLS[equip_type_id] : equip_type_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_EQUIP_FIX, equip_type_id)
        @features.push(feature)
      end

      def seal_equip(equip_type_id)
        equip_type_id = equip_type_id.is_a?(Symbol) ? AstiLib::Database::EQUIP_TYPE_SYMBOLS[equip_type_id] : equip_type_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_EQUIP_SEAL, equip_type_id)
        @features.push(feature)
      end

      # Set the slot type
      # 0 = Normal
      # 1 = Dual Wield
      def set_slot_type(slot_type_id)
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_SLOT_TYPE, slot_type_id)
        @features.push(feature)
      end
    end

    # # Other Features
    # ----------------
    # Methods for adding features from the 'Other' tab.
    module OtherFeatures
      def add_action_times(percent)
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_ACTION_PLUS, 0, percent / 100.0)
        @features.push(feature)
      end

      def add_special_flag(special_flag_id)
        special_flag_id = special_flag_id.is_a?(Symbol) ? AstiLib::Database::SPECIAL_FLAG_TYPES[special_flag_id] : special_flag_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_SPECIAL_FLAG, special_flag_id)
        @features.push(feature)
      end

      def add_collapse_effect(collapse_effect_id)
        collapse_effect_id = collapse_effect_id.is_a?(Symbol) ? AstiLib::Database::COLLAPSE_EFFECT_TYPES[collapse_effect_id] : collapse_effect_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_COLLAPSE_TYPE, collapse_effect_id)
        @features.push(feature)
      end

      def add_party_ability(party_ability_id)
        party_ability_id = party_ability_id.is_a?(Symbol) ? AstiLib::Database::PARTY_ABILITY_TYPES[party_ability_id] : party_ability_id
        feature = RPG::BaseItem::Feature.new(Game_BattlerBase::FEATURE_PARTY_ABILITY, party_ability_id)
        @features.push(feature)
      end
    end

    # # Feature Utils
    # ---------------
    # The methods in this module allow you to manipulate existing features
    module FeatureUtils
      def clear_features
        @features = []
      end
    end
  end
end; end