module AstiLib
  module Database
    @skill_name_procs = {}
    @skill_description_procs = {}
    @message1_procs = {}
    @message2_procs = {}

    def self.create_skill(unique_key, *attributes)
      raise raise_database_error('skill', '$data_skills') unless $data_skills
    
      # Default values for when an skill is created and no attributes are given.
      defaults = {
        # General settings
        name: "Skill",
        description: "",
        icon: 0,
        skill_type: 1,
        mp_cost: 0,
        tp_cost: 0,
        scope: 1,
        occasion: 0,
        # Invocation
        speed: 0,
        success_rate: 100,
        repeats: 1,
        tp_gain: 0,
        hit_type: 0,
        animation: 0,
        # Using message
        message1: "",
        message2: "",
        # Required weapon
        required_weapon_type1: 0,
        required_weapon_type2: 0,
        # Damage
        damage_type: 0,
        damage_element: 0,
        formula: "0",
        variance: 20,
        critical: false,
        # Note
        note: ""
      }
    
      # Index of attributes in '*attributes' if multiple arguments are used.
      argument_indexes = {
        name: 0,
        description: 1,
        icon: 2,
        skill_type: 3,
        mp_cost: 4,
        tp_cost: 5,
        scope: 6,
        occasion: 7,
        speed: 8,
        success_rate: 9,
        repeats: 10,
        tp_gain: 11,
        hit_type: 12,
        animation: 13,
        message1: 14,
        message2: 15,
        required_weapon_type1: 16,
        required_weapon_type2: 17,
        damage_type: 18,
        damage_element: 19,
        formula: 20,
        variance: 21,
        critical: 22,
        note: 23
      }

      raise ArgumentError, "ERROR: Wrong amount of arguments for 'create_skill'. Got #{attributes.length + 1}, expected #{argument_indexes.length + 1} or less." if attributes.length > argument_indexes.length
    
      # Set attributes depending on if a hash or multiple arguments are used.
      if attributes.first.is_a?(Hash)
        skill_data = attributes.first

        BaseItemAttributes.handle_attributes_hash(skill_data, defaults, unique_key, "skill")
        SkillAttributes.handle_attributes_hash(skill_data, defaults, unique_key)
        UsableItemAttributes.handle_attributes_hash(skill_data, defaults)
        DamageAttributes.handle_attributes_hash(skill_data, defaults)
      else
        BaseItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key, "skill")
        SkillAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key)
        UsableItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
        DamageAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
      end
    
      # Reserve an ID or find the reserved ID that exists for this skill
      DatabaseId.handle_id(unique_key, SKILL_KEYS_LIST, $data_skills)
    
      # Create the skill with the given attributes
      $data_skills[@id] = RPG::Skill.new
      skill = $data_skills[@id]
      skill.id = @id
      skill.name = @name
      skill.description = @description
      skill.icon_index = @icon
      skill.stype_id = @skill_type
      skill.mp_cost = @mp_cost
      skill.tp_cost = @tp_cost
      skill.scope = @scope
      skill.occasion = @occasion
      skill.speed = @speed
      skill.success_rate = @success_rate
      skill.repeats = @repeats
      skill.tp_gain = @tp_gain
      skill.hit_type = @hit_type
      skill.animation_id = @animation
      skill.message1 = @message1
      skill.message2 = @message2
      skill.required_wtype_id1 = @required_weapon_type1
      skill.required_wtype_id2 = @required_weapon_type2
      skill.damage.type = @damage_type
      skill.damage.element_id = @damage_element
      skill.damage.formula = @formula
      skill.damage.variance = @variance
      skill.damage.critical = @critical
      skill.note = @note
    
      AstiLib::MethodHooks.trigger_hook(:on_skill_created, skill)
      return skill
    end

    INITIALIZE_SKILLS = lambda do
      # Loop through the stored name procs and initialize the skill names
      @skill_name_procs.each do |unique_key, name_proc|
        skill = find_skill_by_key(unique_key)
        if skill
          skill.name = name_proc.call
        else
          puts "Skill with key #{unique_key} not found."
        end
      end

      # Loop through the stored description procs and initialize the skill descriptions
      @skill_description_procs.each do |unique_key, desc_proc|
        skill = find_skill_by_key(unique_key)
        if skill
          skill.description = desc_proc.call
        else
          puts "Skill with key #{unique_key} not found."
        end
      end

      # Loop through the stored message1 procs and initialize the skill messages
      @message1_procs.each do |unique_key, message1_proc|
        skill = find_skill_by_key(unique_key)
        if skill
          skill.message1 = message1_proc.call
        else
          puts "Skill with key #{unique_key} not found."
        end
      end

      # Loop through the stored message2 procs and initialize the skill messages
      @message2_procs.each do |unique_key, message2_proc|
        skill = find_skill_by_key(unique_key)
        if skill
          skill.message2 = message2_proc.call
        else
          puts "Skill with key #{unique_key} not found."
        end
      end
    end
  end
end

AstiLib::MethodHooks.add_listener(:player_loaded, AstiLib::Database::INITIALIZE_SKILLS)

class RPG::Skill
  include AstiLib::Database::Effects::RecoverEffects
  include AstiLib::Database::Effects::StateEffects
  include AstiLib::Database::Effects::ParameterEffects
  include AstiLib::Database::Effects::OtherEffects
  include AstiLib::Database::Effects::EffectUtils
end