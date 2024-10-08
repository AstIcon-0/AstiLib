module AstiLib; module Database
  module Effects

    module RecoverEffects
      def add_recover_hp(value1, value2)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_RECOVER_HP
        effect.value1 = value1
        effect.value2 = value2
        @effects.push(effect)
      end
    
      def add_recover_mp(value1, value2)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_RECOVER_MP
        effect.value1 = value1
        effect.value2 = value2
        @effects.push(effect)
      end
    
      def add_gain_tp(value)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_GAIN_TP
        effect.value1 = value
        @effects.push(effect)
      end
    end
    
    module StateEffects
      def add_state(state_id, chance)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_ADD_STATE
        effect.data_id = state_id
        effect.value1 = chance.to_f / 100.0
        @effects.push(effect)
      end
    
      def remove_state(state_id, chance)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_REMOVE_STATE
        effect.data_id = state_id
        effect.value1 = chance.to_f / 100.0
        @effects.push(effect)
      end
    end
    
    module ParameterEffects
      def add_buff(param_id, turns)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_ADD_BUFF
        effect.data_id = param_id
        effect.value1 = turns
        @effects.push(effect)
      end
    
      def add_debuff(param_id, turns)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_ADD_DEBUFF
        effect.data_id = param_id
        effect.value1 = turns
        @effects.push(effect)
      end
    
      def remove_buff(param_id)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_REMOVE_BUFF
        effect.data_id = param_id
        @effects.push(effect)
      end
    
      def remove_debuff(param_id)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_REMOVE_DEBUFF
        effect.data_id = param_id
        @effects.push(effect)
      end
    end
    
    module OtherEffects
      def add_special(special_id)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_SPECIAL
        effect.data_id = special_id
        @effects.push(effect)
      end
    
      def add_grow(param_id, value)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_GROW
        effect.data_id = param_id
        effect.value1 = value
        @effects.push(effect)
      end
    
      def learn_skill(skill_id)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_LEARN_SKILL
        effect.data_id = skill_id
        @effects.push(effect)
      end
    
      def trigger_common_event(event_id)
        effect = RPG::UsableItem::Effect.new
        effect.code = Game_Battler::EFFECT_COMMON_EVENT
        effect.data_id = event_id
        @effects.push(effect)
      end
    end

    module EffectUtils
      def clear_effects
        @effects = []
      end
    end
  end
end; end