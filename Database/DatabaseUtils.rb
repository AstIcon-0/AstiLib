module AstiLib
  module Database

    # Create parameter growth curves for classes.
    # This method generates a Table with x = 8 and y = 100 to represent the growth curves for different parameters.
    # 
    # **Note:** 8 formulas must be provided, one for each parameter.
    # The order you must provide them in is:
    # - Max HP
    # - Max MP
    # - Attack
    # - Defense
    # - Magic Attack
    # - Magic Defense
    # - Agility
    # - Luck
    #
    # @param [Array<String>] formulas An array of 8 formulas as strings, each representing how the parameter should grow by level.
    #                                 Use 'lvl' in the formula to refer to the level (e.g., "5*lvl + 20").
    # @return [Table] The generated Table containing values for each parameter at each level.
    def self.create_param_curves(*formulas)
      raise ArgumentError, "8 formulas must be provided" if formulas.length < 8
    
      table = Table.new(8, 100)
    
      (0...8).each do |x|
        formula = formulas[x]
        (1...100).each do |y|
          level = y
          table[x, y] = eval(formula.gsub('lvl', level.to_s))
        end
      end
    
      return table
    end

    #==============================================================================
    # Methods for finding database items.
    #==============================================================================

    # Search for actors by name.
    # `$data_actors` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the actor you found. Is a string if return_details = true.
    def self.find_actor(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_actors = []

      # Iterate through all actors in the database
      $data_actors.each_with_index do |actor, index|
        next if actor.nil?

        # Check if the actor's name includes the search string
        if actor.name.downcase.include?(search_string_downcase)
          if return_details
            matching_actors << "ID: #{index} Name: #{actor.name}"
          else
            matching_actors << index
          end
        end
      end

      return matching_actors
    end

    def self.find_actor_by_key(unique_key)
      actor_id = AstiLib::FileData.load_var_from_file(unique_key, ACTOR_KEYS_LIST, true)
      return nil unless actor_id
      return $data_actors[actor_id]
    end

    # Search for classes by name.
    # `$data_classes` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the class you found. Is a string if return_details = true.
    def self.find_class(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_classes = []

      # Iterate through all classes in the database
      $data_classes.each_with_index do |actor_class, index|
        next if actor_class.nil?

        # Check if the class' name includes the search string
        if actor_class.name.downcase.include?(search_string_downcase)
          if return_details
            matching_classes << "ID: #{index} Name: #{actor_class.name}"
          else
            matching_classes << index
          end
        end
      end

      return matching_classes
    end

    def self.find_class_by_key(unique_key)
      class_id = AstiLib::FileData.load_var_from_file(unique_key, CLASS_KEYS_LIST, true)
      return nil unless class_id
      return $data_classes[class_id]
    end

    # Search for skills by name.
    # `$data_skills` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the skill you found. Is a string if return_details = true.
    def self.find_skill(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_skills = []

      # Iterate through all skills in the database
      $data_skills.each_with_index do |skill, index|
        next if skill.nil?

        # Check if the skill's name includes the search string
        if skill.name.downcase.include?(search_string_downcase)
          if return_details
            matching_skills << "ID: #{index} Name: #{skill.name}"
          else
            matching_skills << index
          end
        end
      end

      return matching_skills
    end

    def self.find_skill_by_key(unique_key)
      skill_id = AstiLib::FileData.load_var_from_file(unique_key, SKILL_KEYS_LIST, true)
      return nil unless skill_id
      return $data_skills[skill_id]
    end

    # Search for items by name.
    # `$data_items` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the skill you found. Is a string if return_details = true.
    def self.find_item(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_items = []

      # Iterate through all items in the database
      $data_items.each_with_index do |item, index|
        next if item.nil?

        # Check if the item's name includes the search string
        if item.name.downcase.include?(search_string_downcase)
          if return_details
            matching_items << "ID: #{index} Name: #{item.name}"
          else
            matching_items << index
          end
        end
      end

      return matching_items
    end

    def self.find_item_by_key(unique_key)
      item_id = AstiLib::FileData.load_var_from_file(unique_key, ITEM_KEYS_LIST, true)
      return nil unless item_id
      return $data_items[item_id]
    end

    # Search for weapons by name.
    # `$data_weapons` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the weapon you found. Is a string if return_details = true.
    def self.find_weapon(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_weapons = []

      # Iterate through all weapons in the database
      $data_weapons.each_with_index do |weapon, index|
        next if weapon.nil?

        # Check if the weapon's name includes the search string
        if weapon.name.downcase.include?(search_string_downcase)
          if return_details
            matching_weapons << "ID: #{index} Name: #{weapon.name}"
          else
            matching_weapons << index
          end
        end
      end

      return matching_weapons
    end

    def self.find_weapon_by_key(unique_key)
      weapon_id = AstiLib::FileData.load_var_from_file(unique_key, WEAPON_KEYS_LIST, true)
      return nil unless weapon_id
      return $data_weapons[weapon_id]
    end

    # Search for armors by name.
    # `$data_armors` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the armor you found. Is a string if return_details = true.
    def self.find_armor(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_armors = []

      # Iterate through all armors in the database
      $data_armors.each_with_index do |armor, index|
        next if armor.nil?

        # Check if the armor's name includes the search string
        if armor.name.downcase.include?(search_string_downcase)
          if return_details
            matching_armors << "ID: #{index} Name: #{armor.name}"
          else
            matching_armors << index
          end
        end
      end

      return matching_armors
    end

    def self.find_armor_by_key(unique_key)
      armor_id = AstiLib::FileData.load_var_from_file(unique_key, ARMOR_KEYS_LIST, true)
      return nil unless armor_id
      return $data_armors[armor_id]
    end

    # Search for enemies by name.
    # `$data_enemies` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the enemy you found. Is a string if return_details = true.
    def self.find_enemy(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_enemies = []

      # Iterate through all enemies in the database
      $data_enemies.each_with_index do |enemy, index|
        next if enemy.nil?

        # Check if the enemy's name includes the search string
        if enemy.name.downcase.include?(search_string_downcase)
          if return_details
            matching_enemies << "ID: #{index} Name: #{enemy.name}"
          else
            matching_enemies << index
          end
        end
      end

      return matching_enemies
    end

    def self.find_enemy_by_key(unique_key)
      enemy_id = AstiLib::FileData.load_var_from_file(unique_key, ENEMY_KEYS_LIST, true)
      return nil unless enemy_id
      return $data_enemies[enemy_id]
    end

    # Search for troops by name.
    # `$data_troops` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the troop you found. Is a string if return_details = true.
    def self.find_troop(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_troops = []

      # Iterate through all troops in the database
      $data_troops.each_with_index do |troop, index|
        next if troop.nil?

        # Check if the troop's name includes the search string
        if troop.name.downcase.include?(search_string_downcase)
          if return_details
            matching_troops << "ID: #{index} Name: #{troop.name}"
          else
            matching_troops << index
          end
        end
      end

      return matching_troops
    end

    # Search for states by name.
    # `$data_states` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the state you found. Is a string if return_details = true.
    def self.find_state(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_states = []

      # Iterate through all states in the database
      $data_states.each_with_index do |state, index|
        next if state.nil?

        # Check if the state's name includes the search string
        if state.name.downcase.include?(search_string_downcase)
          if return_details
            matching_states << "ID: #{index} Name: #{state.name}"
          else
            matching_states << index
          end
        end
      end

      return matching_states
    end

    # Search for animations by name.
    # `$data_animations` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the animation you found. Is a string if return_details = true.
    def self.find_animation(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_animations = []

      # Iterate through all animations in the database
      $data_animations.each_with_index do |animation, index|
        next if animation.nil?

        # Check if the animation's name includes the search string
        if animation.name.downcase.include?(search_string_downcase)
          if return_details
            matching_animations << "ID: #{index} Name: #{animation.name}"
          else
            matching_animations << index
          end
        end
      end

      return matching_animations
    end

    # Search for tilesets by name.
    # `$data_tilesets` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the tileset you found. Is a string if return_details = true.
    def self.find_tileset(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_tilesets = []

      # Iterate through all tilesets in the database
      $data_tilesets.each_with_index do |tileset, index|
        next if tileset.nil?

        # Check if the tileset's name includes the search string
        if tileset.name.downcase.include?(search_string_downcase)
          if return_details
            matching_tilesets << "ID: #{index} Name: #{tileset.name}"
          else
            matching_tilesets << index
          end
        end
      end

      return matching_tilesets
    end

    # Search for common events by name.
    # `$data_common events` **must have loaded before you can use this function**.
    # 
    # @param [String] search_string
    # @param [Boolean] return_details if true also return the name.
    # @return [Array<Integer>] The IDs of the common event you found. Is a string if return_details = true.
    def self.find_common_event(search_string, return_details = false)
      search_string_downcase = search_string.downcase
      matching_common_events = []

      # Iterate through all common events in the database
      $data_common_events.each_with_index do |common_event, index|
        next if common_event.nil?

        # Check if the common event's name includes the search string
        if common_event.name.downcase.include?(search_string_downcase)
          if return_details
            matching_common_events << "ID: #{index} Name: #{common_event.name}"
          else
            matching_common_events << index
          end
        end
      end

      return matching_common_events
    end

    #==============================================================================
    # Methods for printing item data.
    #==============================================================================

    # Print actor data by ID or RPG::Actor object.
    #
    # @param [Integer, RPG::Actor] actor_id The ID of the actor or the RPG::Actor object.
    # @return [String] The formatted actor data or "Actor not found" if the actor is invalid.
    def self.print_actor_data(actor_id)
      actor = actor_id.is_a?(RPG::Actor) ? actor_id : $data_actors[actor_id]

      unless actor
        puts "Actor not found"
        return "Actor not found"
      end

      data_str = ""
      data_str << "\n-- ID --\n#{actor.id}"
      data_str << "\n-- Name --\n#{actor.name}"
      data_str << "\n-- Nickname --\n#{actor.nickname}"
      data_str << "\n-- Class --\n#{actor.class_id} (#{$data_classes[actor.class_id].name})"
      data_str << "\n-- Initial level --\n#{actor.initial_level}"
      data_str << "\n-- Max level --\n#{actor.max_level}"
      data_str << "\n-- Description --\n#{actor.description}"
      data_str << "\n-- Character --\nindex: #{actor.character_index}\nname: #{actor.character_name}"
      data_str << "\n-- Face --\nindex: #{actor.face_index}\nname: #{actor.face_name}"
      data_str << "\n-- Starting equipment --\n#{actor.equips.inspect}"
      data_str << "\n-- Features --"
      actor.features.length > 0 ? data_str << features_to_string(actor.features) : data_str << "\nNone"
      data_str << "\n-- Notes --\n#{actor.note}"
      puts data_str + "\n-------\n"
      return data_str
    end

    # Print class data by ID or RPG::Class object.
    #
    # @param [Integer, RPG::Class] class_id The ID of the class or the RPG::Class object.
    # @param [Integer] levels_to_display The interval of levels diplayed in the parameter curve. Default is 10, which displays lv: 1, 10, 20, ect..
    # @return [String] The formatted class data or "Class not found" if the class is invalid.
    def self.print_class_data(class_id, levels_to_display = 10)
      actor_class = class_id.is_a?(RPG::Class) ? class_id : $data_classes[class_id]

      unless actor_class
        puts "Class not found"
        return "Class not found"
      end

      levels_to_display = 1 if levels_to_display < 1

      data_str = ""
      data_str << "\n-- ID --\n#{actor_class.id}"
      data_str << "\n-- Name --\n#{actor_class.name}"
      data_str << "\n-- EXP curve --"
      actor_class.exp_params.each_with_index do |exp_param_value, index|
        data_str << "\n#{exp_curve_name(index)}: #{exp_param_value}"
      end
      data_str << "\n-- Parameter curve --\n#{format_params_table(actor_class.params, levels_to_display)}"
      data_str << "\n-- Skill learnings --"
      actor_class.learnings.each do |learning|
        data_str << "\nLevel: #{learning.level}, skill: #{learning.skill_id} (#{$data_skills[learning.skill_id].name}), note: #{learning.note}"
      end
      data_str << "\n-- Features --"
      actor_class.features.length > 0 ? data_str << features_to_string(actor_class.features) : data_str << "\nNone"
      data_str << "\n-- Notes --\n#{actor_class.note}"
      puts data_str + "\n-------\n"
      return data_str
    end

    # Print skill data by ID or RPG::Skill object.
    #
    # @param [Integer, RPG::Skill] skill_id The ID of the skill or the RPG::Skill object.
    # @return [String] The formatted skill data or "Skill not found" if the skill is invalid.
    def self.print_skill_data(skill_id)
      skill = skill_id.is_a?(RPG::Skill) ? skill_id : $data_skills[skill_id]

      unless skill
        puts "Skill not found"
        return "Skill not found"
      end

      data_str = ""
      data_str << "\n-- ID --\n#{skill.id}"
      data_str << "\n-- Name --\n#{skill.name}"
      data_str << "\n-- Icon index --\n#{skill.icon_index}"
      data_str << "\n-- Description --\n#{skill.description}"
      data_str << "\n-- Skill type --\n#{skill.stype_id} (#{skill.stype_id > 0 ? $data_system.skill_types[skill.stype_id] : "None"})"
      data_str << "\n-- Cost --\nMP: #{skill.mp_cost}\nTP: #{skill.tp_cost}"
      data_str << "\n-- Scope --\n#{skill.scope} (#{scope_name(skill.scope)})"
      data_str << "\n-- Occasion --\n#{skill.occasion} (#{occasion_name(skill.occasion)})"
      data_str << "\n-- Speed --\n#{skill.speed}"
      data_str << "\n-- Success rate --\n#{skill.success_rate}%"
      data_str << "\n-- Repeats --\n#{skill.repeats}"
      data_str << "\n-- TP gain --\n#{skill.tp_gain}"
      data_str << "\n-- Hit type --\n#{skill.hit_type} (#{hit_type_name(skill.hit_type)})"
      data_str << "\n-- Animation --"
      if skill.animation_id == -1
        data_str << "\n#{skill.animation_id} (Normal Attack)"
      elsif skill.animation_id == 0
        data_str << "\n#{skill.animation_id} (None)"
      else
        data_str << "\n#{skill.animation_id} (#{$data_animations[skill.animation_id].name})"
      end
      data_str << "\n-- Use message --\nMessage 1: \"(User Name)#{skill.message1}\"\nMessage 2: \"#{skill.message2}\""
      data_str << "\n-- Required weapon type --"
      data_str << "\nWeapon type 1: #{skill.required_wtype_id1} " + 
      "(#{$data_system.weapon_types[skill.required_wtype_id1].to_s.empty? ? "None" : $data_system.weapon_types[skill.required_wtype_id1]})"
      data_str << "\nWeapon type 2: #{skill.required_wtype_id2} " +
      "(#{$data_system.weapon_types[skill.required_wtype_id2].to_s.empty? ? "None" : $data_system.weapon_types[skill.required_wtype_id2]})"
      data_str << "\n-- Damage type --\n#{skill.damage.type} (#{damage_type_name(skill.damage.type)})"
      data_str << "\n-- Damage element --"
      if skill.damage.element_id == -1
        data_str << "\n#{skill.damage.element_id} (Normal Attack)"
      elsif skill.damage.element_id == 0
        data_str << "\n#{skill.damage.element_id} (None)"
      else
        data_str << "\n#{skill.damage.element_id} (#{$data_system.elements[skill.damage.element_id]})"
      end
      data_str << "\n-- Damage formula --\n#{skill.damage.formula}"
      data_str << "\n-- Damage variance --\n#{skill.damage.variance}"
      data_str << "\n-- Damage critical --\n#{skill.damage.critical}"
      data_str << "\n-- Effects --"
      skill.effects.length > 0 ? data_str << effects_to_string(skill.effects) : data_str << "\nNone"
      data_str << "\n-- Notes --\n#{skill.note}"
      puts data_str + "\n-------\n"
      return data_str
    end

    # Print item data by ID or RPG::Item object.
    #
    # @param [Integer, RPG::Item] item_id The ID of the item or the RPG::Item object.
    # @return [String] The formatted item data or "Item not found" if the item is invalid.
    def self.print_item_data(item_id)
      item = item_id.is_a?(RPG::Item) ? item_id : $data_items[item_id]

      unless item
        puts "Item not found"
        return "Item not found"
      end

      data_str = ""
      data_str << "\n-- ID --\n#{item.id}"
      data_str << "\n-- Name --\n#{item.name}"
      data_str << "\n-- Icon index --\n#{item.icon_index}"
      data_str << "\n-- Description --\n#{item.description}"
      data_str << "\n-- Item type --\n#{item.itype_id} (#{item.itype_id == 1 ? "Normal" : "Key Item"})"
      data_str << "\n-- Price --\n#{item.price}"
      data_str << "\n-- Consume --\n#{item.consumable}"
      data_str << "\n-- Scope --\n#{item.scope} (#{scope_name(item.scope)})"
      data_str << "\n-- Occasion --\n#{item.occasion} (#{occasion_name(item.occasion)})"
      data_str << "\n-- Speed --\n#{item.speed}"
      data_str << "\n-- Success rate --\n#{item.success_rate}%"
      data_str << "\n-- Repeats --\n#{item.repeats}"
      data_str << "\n-- TP gain --\n#{item.tp_gain}"
      data_str << "\n-- Hit type --\n#{item.hit_type} (#{hit_type_name(item.hit_type)})"
      data_str << "\n-- Animation --"
      if item.animation_id == -1
        data_str << "\n#{item.animation_id} (Normal Attack)"
      elsif item.animation_id == 0
        data_str << "\n#{item.animation_id} (None)"
      else
        data_str << "\n#{item.animation_id} (#{$data_animations[item.animation_id].name})"
      end
      data_str << "\n-- Damage type --\n#{item.damage.type} (#{damage_type_name(item.damage.type)})"
      data_str << "\n-- Damage element --"
      if item.damage.element_id == -1
        data_str << "\n#{item.damage.element_id} (Normal Attack)"
      elsif item.damage.element_id == 0
        data_str << "\n#{item.damage.element_id} (None)"
      else
        data_str << "\n#{item.damage.element_id} (#{$data_system.elements[item.damage.element_id]})"
      end
      data_str << "\n-- Damage formula --\n#{item.damage.formula}"
      data_str << "\n-- Damage variance --\n#{item.damage.variance}"
      data_str << "\n-- Damage critical --\n#{item.damage.critical}"
      data_str << "\n-- Effects --"
      item.effects.length > 0 ? data_str << effects_to_string(item.effects) : data_str << "\nNone"
      data_str << "\n-- Notes --\n#{item.note}"
      puts data_str + "\n-------\n"
      return data_str
    end

    # Print weapon data by ID or RPG::Weapon object.
    #
    # @param [Integer, RPG::Weapon] weapon_id The ID of the weapon or the RPG::Weapon object.
    # @return [String] The formatted weapon data or "Weapon not found" if the weapon is invalid.
    def self.print_weapon_data(weapon_id)
      weapon = weapon_id.is_a?(RPG::Weapon) ? weapon_id : $data_weapons[weapon_id]

      unless weapon
        puts "Weapon not found"
        return "Weapon not found"
      end

      data_str = ""
      data_str << "\n-- ID --\n#{weapon.id}"
      data_str << "\n-- Name --\n#{weapon.name}"
      data_str << "\n-- Icon index --\n#{weapon.icon_index}"
      data_str << "\n-- Description --\n#{weapon.description}"
      data_str << "\n-- Weapon type --\n#{weapon.wtype_id} (#{$data_system.weapon_types[weapon.wtype_id]})"
      data_str << "\n-- Parameters --"
      (0..7).each do |param_id|
        data_str << "\n#{param_name(param_id)}: #{weapon.params[param_id]}"
      end
      data_str << "\n-- Features --"
      weapon.features.length > 0 ? data_str << features_to_string(weapon.features) : data_str << "\nNone"
      data_str << "\n-- Animation ID --\n#{weapon.animation_id}"
      data_str << "\n-- Price --\n#{weapon.price}"
      data_str << "\n-- Notes --\n#{weapon.note}"
      puts data_str + "\n-------\n"
      return data_str
    end

    # Print armor data by ID or RPG::Armor object.
    #
    # @param [Integer, RPG::Armor] armor_id The ID of the armor or the RPG::Armor object.
    # @return [String] The formatted armor data or "Armor not found" if the armor is invalid.
    def self.print_armor_data(armor_id)
      armor = armor_id.is_a?(RPG::Armor) ? armor_id : $data_armors[armor_id]
      
      unless armor
        puts "Armor not found"
        return "Armor not found"
      end

      data_str = ""
      data_str << "\n-- ID --\n#{armor.id}"
      data_str << "\n-- Name --\n#{armor.name}"
      data_str << "\n-- Icon index --\n#{armor.icon_index}"
      data_str << "\n-- Description --\n#{armor.description}"
      data_str << "\n-- Armor type --\n#{armor.atype_id} (#{$data_system.armor_types[armor.atype_id]})"
      data_str << "\n-- Parameters --"
      (0..7).each do |param_id|
        data_str << "\n#{param_name(param_id)}: #{armor.params[param_id]}"
      end
      data_str << "\n-- Features --"
      armor.features.length > 0 ? data_str << features_to_string(armor.features) : data_str << "\nNone"
      data_str << "\n-- Equip type --\n#{armor.etype_id} (#{equip_type_name(armor.etype_id)})"
      data_str << "\n-- Price --\n#{armor.price}"
      data_str << "\n-- Notes --\n#{armor.note}"
      puts data_str + "\n-------\n"
      return data_str
    end

    class << self
      private

      def format_params_table(params_table, levels_to_display)
        return "No data available" if params_table.nil?
    
        formatted_str = ""
        # Assuming the Table object represents parameters across different levels
        (0...params_table.xsize).each do |param_id|
          formatted_str << "#{param_name(param_id)}:\n"
          
          formatted_str << "  Lv 1: #{params_table[param_id, 1]}\n" if params_table[param_id, 1]
    
          # Display levels based on step size
          step = levels_to_display
          level = step
          while level < params_table.ysize
            formatted_str << "  Lv #{level}: #{params_table[param_id, level]}\n"
            level += step
          end
    
          formatted_str << "\n" unless params_table.xsize - 1 == param_id
        end
        return formatted_str
      end

      # Convert features into a formatted string.
      #
      # @param [Array<RPG::BaseItem::Feature>] features The list of features.
      # @return [String] The formatted string representation of the features.
      def features_to_string(features)
        feature_str = ""
        features.each do |feature|
          case feature.code
          when Game_BattlerBase::FEATURE_ELEMENT_RATE
            element_name = $data_system.elements[feature.data_id]
            element_name = "Element doesn't exist" unless element_name
            feature_str << "\nElement rate: #{feature.data_id} (#{element_name}), #{feature.value * 100}%"
          when Game_BattlerBase::FEATURE_DEBUFF_RATE
            param_name = param_name(feature.data_id)
            feature_str << "\nDebuff rate: #{param_name}, #{feature.value * 100}%"
          when Game_BattlerBase::FEATURE_STATE_RATE
            state = $data_states[feature.data_id]
            state_name = state ? state.name : "State doesn't exist"
            feature_str << "\nState rate: #{feature.data_id} (#{state_name}), #{feature.value * 100}%"
          when Game_BattlerBase::FEATURE_STATE_RESIST
            state = $data_states[feature.data_id]
            state_name = state ? state.name : "State doesn't exist"
            feature_str << "\nState resist: #{feature.data_id} (#{state_name})"
          when Game_BattlerBase::FEATURE_PARAM
            param_name = param_name(feature.data_id)
            feature_str << "\nParameter: #{param_name}, * #{feature.value * 100}%"
          when Game_BattlerBase::FEATURE_XPARAM
            ex_param_name = ex_param_name(feature.data_id)
            feature_str << "\nEx-Parameter: #{ex_param_name}, #{feature.value >= 0 ? '+' : '-'}#{feature.value.abs * 100}%"
          when Game_BattlerBase::FEATURE_SPARAM
            sp_param_name = sp_param_name(feature.data_id)
            feature_str << "\nSp-Parameter: #{sp_param_name}, * #{feature.value * 100}%"
          when Game_BattlerBase::FEATURE_ATK_ELEMENT
            element_name = $data_system.elements[feature.data_id]
            element_name = "Element doesn't exist" unless element_name
            feature_str << "\nAttack element: #{feature.data_id} (#{element_name})"
          when Game_BattlerBase::FEATURE_ATK_STATE
            state = $data_states[feature.data_id]
            state_name = state ? state.name : "State doesn't exist"
            feature_str << "\nAttack state: #{feature.data_id} (#{state_name}), #{feature.value * 100}%"
          when Game_BattlerBase::FEATURE_ATK_SPEED
            feature_str << "\nAttack speed: #{feature.value >= 0 ? '+' : '-'}#{feature.value.to_i}"
          when Game_BattlerBase::FEATURE_ATK_TIMES
            feature_str << "\nAttack times: #{feature.value >= 0 ? '+' : '-'}#{feature.value.to_i}"
          when Game_BattlerBase::FEATURE_STYPE_ADD
            skill_type_name = $data_system.skill_types[feature.data_id]
            skill_type_name = "Skill type doesn't exist" unless skill_type_name
            feature_str << "\nAdd skill type: #{feature.data_id} (#{skill_type_name})"
          when Game_BattlerBase::FEATURE_STYPE_SEAL
            skill_type_name = $data_system.skill_types[feature.data_id]
            skill_type_name = "Skill type doesn't exist" unless skill_type_name
            feature_str << "\nSeal skill type: #{feature.data_id} (#{skill_type_name})"
          when Game_BattlerBase::FEATURE_SKILL_ADD
            skill = $data_skills[feature.data_id]
            skill_name = skill ? skill.name : "Skill doesn't exist"
            feature_str << "\nAdd skill: #{feature.data_id} (#{skill_name})"
          when Game_BattlerBase::FEATURE_SKILL_SEAL
            skill = $data_skills[feature.data_id]
            skill_name = skill ? skill.name : "Skill doesn't exist"
            feature_str << "\nSeal skill: #{feature.data_id} (#{skill_name})"
          when Game_BattlerBase::FEATURE_EQUIP_WTYPE
            weapon_type_name = $data_system.weapon_types[feature.data_id]
            weapon_type_name = "Weapon type doesn't exist" unless weapon_type_name
            feature_str << "\nEquip weapon: #{feature.data_id} (#{weapon_type_name})"
          when Game_BattlerBase::FEATURE_EQUIP_ATYPE
            armor_type_name = $data_system.armor_types[feature.data_id]
            armor_type_name = "Armor type doesn't exist" unless armor_type_name
            feature_str << "\nEquip armor: #{feature.data_id} (#{armor_type_name})"
          when Game_BattlerBase::FEATURE_EQUIP_FIX
            equip_type_name = equip_type_name(feature.data_id)
            feature_str << "\nFix equip: #{feature.data_id} (#{equip_type_name})"
          when Game_BattlerBase::FEATURE_EQUIP_SEAL
            equip_type_name = equip_type_name(feature.data_id)
            feature_str << "\nSeal equip: #{feature.data_id} (#{equip_type_name})"
          when Game_BattlerBase::FEATURE_SLOT_TYPE
            slot_type = feature.value.to_i == 1 ? 'Dual Wield' : 'Normal'
            feature_str << "\nSlot type: #{slot_type}"
          when Game_BattlerBase::FEATURE_ACTION_PLUS
            feature_str << "\nAction times: #{feature.value >= 0 ? '+' : '-'}#{(feature.value * 100)}%"
          when Game_BattlerBase::FEATURE_SPECIAL_FLAG
            special_flag_name = special_flag_name(feature.data_id)
            feature_str << "\nSpecial flag: #{feature.data_id} (#{special_flag_name})"
          when Game_BattlerBase::FEATURE_COLLAPSE_TYPE
            collapse_effect_name = collapse_effect_name(feature.data_id)
            feature_str << "\nCollapse effect: #{feature.data_id} (#{collapse_effect_name})"
          when Game_BattlerBase::FEATURE_PARTY_ABILITY
            party_ability_name = party_ability_name(feature.data_id)
            feature_str << "\nParty ability: #{feature.data_id} (#{party_ability_name})"
          else
            feature_str << "\nUnknown feature: Code #{feature.code}, Data ID #{feature.data_id}, Value #{feature.value}"
          end
        end
        return feature_str
      end

      # Convert effects into a formatted string.
      #
      # @param [Array<RPG::UsableItem::Effect>] effects The list of effects.
      # @return [String] The formatted string representation of the effects.
      def effects_to_string(effects)
        effect_str = ""
        effects.each do |effect|
          case effect.code
          when Game_Battler::EFFECT_RECOVER_HP
            effect_str << "\nRecover HP: #{effect.value1 * 100}% + #{effect.value2.to_i} HP"
          when Game_Battler::EFFECT_RECOVER_MP
            effect_str << "\nRecover MP: #{effect.value1 * 100}% + #{effect.value2.to_i} MP"
          when Game_Battler::EFFECT_GAIN_TP
            effect_str << "\nGain TP: #{effect.value1.to_i} TP"
          when Game_Battler::EFFECT_ADD_STATE
            if effect.data_id == 0
              state_name = "Normal Attack"
            else
              state = $data_states[effect.data_id]
              state_name = state ? state.name : "State doesn't exist"
            end
            effect_str << "\nAdd State: #{effect.data_id} (#{state_name}), #{effect.value1 * 100}%"
          when Game_Battler::EFFECT_REMOVE_STATE
            state = $data_states[effect.data_id]
            state_name = state ? state.name : "State doesn't exist"
            effect_str << "\nRemove State: #{effect.data_id} (#{state_name}), #{effect.value1 * 100}%"
          when Game_Battler::EFFECT_ADD_BUFF
            param_name = param_name(effect.data_id)
            effect_str << "\nAdd Buff: #{param_name}, #{effect.value1.to_i} turns"
          when Game_Battler::EFFECT_ADD_DEBUFF
            param_name = param_name(effect.data_id)
            effect_str << "\nAdd Debuff: #{param_name}, #{effect.value1.to_i} turns"
          when Game_Battler::EFFECT_REMOVE_BUFF
            param_name = param_name(effect.data_id)
            effect_str << "\nRemove Buff: #{param_name}"
          when Game_Battler::EFFECT_REMOVE_DEBUFF
            param_name = param_name(effect.data_id)
            effect_str << "\nRemove Debuff: #{param_name}"
          when Game_Battler::EFFECT_SPECIAL
            special_effect_name = special_effect_name(effect.data_id)
            effect_str << "\nSpecial Effect: #{special_effect_name}"
          when Game_Battler::EFFECT_GROW
            param_name = param_name(effect.data_id)
            effect_str << "\nGrow Parameter: #{param_name}, +#{effect.value1.to_i}"
          when Game_Battler::EFFECT_LEARN_SKILL
            skill = $data_skills[effect.data_id]
            skill_name = skill ? skill.name : "Skill doesn't exist"
            effect_str << "\nLearn Skill: #{effect.data_id} (#{skill_name})"
          when Game_Battler::EFFECT_COMMON_EVENT
            common_event = $data_common_events[effect.data_id]
            event_name = common_event ? common_event.name : "Common Event doesn't exist"
            effect_str << "\nTrigger Common Event: #{effect.data_id} (#{event_name})"
          else
            effect_str << "\nUnknown Effect: Code #{effect.code}, Data ID #{effect.data_id}, Value1 #{effect.value1}, Value2 #{effect.value2}"
          end
        end
        return effect_str
      end

      # Get the name of an ex-parameter by ID.
      #
      # @param [Integer] param_id The ex-parameter ID.
      # @return [String] The name of the ex-parameter.
      def ex_param_name(param_id)
        terms = ['Hit Rate', 'Evasion Rate', 'Critical Rate', 'Critical Evasion Rate', 'Magic Evasion Rate', 
                'Magic Reflection Rate', 'Counterattack Rate', 'HP Regeneration Rate', 'MP Regeneration Rate', 'TP Regeneration Rate']
        return terms[param_id]
      end

      # Get the name of an sp-parameter by ID.
      #
      # @param [Integer] param_id The sp-parameter ID.
      # @return [String] The name of the sp-parameter.
      def sp_param_name(param_id)
        terms = ['Target Rate', 'Guard Effect Rate', 'Recovery Effect Rate', 'Pharmacology', 'MP Cost Rate', 
                'TP Charge Rate', 'Physical Damage Rate', 'Magical Damage Rate', 'Floor Damage Rate', 'Experience Rate']
        return terms[param_id]
      end

      # Get the name of an equipment type by ID.
      #
      # @param [Integer] equip_type_id The equipment type ID.
      # @return [String] The name of the equipment type.
      def equip_type_name(equip_type_id)
        term = ['Weapon', 'Shield', 'Head', 'Body', 'Accessory']
        return term[equip_type_id]
      end

      # Get the name of a special flag by ID.
      #
      # @param [Integer] flag_id The special flag ID.
      # @return [String] The name of the special flag.
      def special_flag_name(flag_id)
        terms = ['Auto Battle', 'Guard', 'Substitute', 'Preserve TP']
        return terms[flag_id]
      end

      # Get the name of a collapse effect by ID.
      #
      # @param [Integer] effect_id The collapse effect ID.
      # @return [String] The name of the collapse effect.
      def collapse_effect_name(effect_id)
        terms = ['Normal', 'Boss', 'Instant', 'No Disappear', 'No Collapse']
        return terms[effect_id]
      end

      # Get the name of a party ability by ID.
      #
      # @param [Integer] ability_id The party ability ID.
      # @return [String] The name of the party ability.
      def party_ability_name(ability_id)
        terms = ['Encounter Half', 'Encounter None', 'Cancel Surprise', 'Raise Preemptive', 'Gold Double', 
                'Drop Item Double']
        return terms[ability_id]
      end

      def scope_name(scope_id)
        terms = ['None', 'One Enemy', 'All Enemies', '1 Random Enemy', '2 Random Enemies', '3 Random Enemies', '4 Random Enemies',
                'One Ally', 'All Allies', 'One Ally (Dead)', 'All Allies (Dead)', 'The User']
        return terms[scope_id]
      end

      def occasion_name(occasion_id)
        terms = ['Always', 'Only in Battle', 'Only from the Menu', 'Never']
        return terms[occasion_id]
      end

      def hit_type_name(hit_type_id)
        terms = ['Certain Hit', 'Physical Attack', 'Magical Attack']
        return terms[hit_type_id]
      end

      def damage_type_name(hit_type_id)
        terms = ['None', 'HP Damage', 'MP Damage', 'HP Recover', 'MP Recover', 'HP Drain', 'MP Drain']
        return terms[hit_type_id]
      end

      # Get the parameter name by ID.
      #
      # @param [Integer] param_id The parameter ID.
      # @return [String] The name of the parameter.
      def param_name(param_id)
        return $data_system.terms.params[param_id]
      end

      def exp_curve_name(value_id)
        case value_id
        when 0
          return "Base value"
        when 1
          return "Extra value"
        when 2
          return "Acceleration A"
        when 3
          return "Acceleration B"
        else
          return "Unknown curve value"
        end
      end

      # Retrieves the name of a special effect.
      def special_effect_name(data_id)
        case data_id
        when 0; "Escape"
        else; "Unknown Special Effect"
        end
      end
    end
  end
end