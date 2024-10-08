module AstiLib
  module Database

    # # Database ID
    # -------------
    # This module contains a method to handle the ID of classes in the database.
    module DatabaseId

      # Checks if a class has an reserved ID in the matching list based on the class' key.
      # If it hasn't it will receive an ID and reserve it in the list.
      # 
      # @param [String] unique_key
      # @param [String] id_list
      # @param [Array<RPG::BaseItem>] data_type
      # @return [Nil]
      def self.handle_id(unique_key, id_list, data_type)
        unique_key = unique_key.to_s
        id = AstiLib::FileData.load_var_from_file(unique_key, id_list, true)
        unless id
          id = AstiLib::FileData.load_all_vars_from_file(id_list, true).values.max

          if id
            id += 1
            AstiLib::FileData.save_var_to_file(unique_key, id, id_list, true)
          else
            id = (data_type.compact.map(&:id).max || 0) + 1
            AstiLib::FileData.save_var_to_file(unique_key, id, id_list, true)
          end

        end
        AstiLib::Database.instance_variable_set(:@id, id)
      end
    end

    # # Base Item Attributes
    # ----------------------
    # This module contains methods for handling the attributes of the `RPG::BaseItem` class.
    module BaseItemAttributes

      # Handles the attribues if the arguments for the object's data was given as a Hash
      def self.handle_attributes_hash(data, defaults, unique_key, type, options = {})
        handle_name = options.fetch(:name, true)
        handle_description = options.fetch(:description, true)
        handle_icon = options.fetch(:icon, true)
        handle_note = options.fetch(:note, true)

        name_procs_var = "@#{type}_name_procs"
        description_procs_var = "@#{type}_description_procs"

        if handle_name
          name_value = data[:name]
          unless name_value.nil? || name_value.is_a?(String) || name_value.is_a?(Proc)
            raise "ERROR: `name` must be a String or Proc, but got #{name_value.class}."
          end
      
          name = data.fetch(:name, defaults[:name])
      
          # If name is a Proc, store it for later use
          if name.is_a?(Proc)
            AstiLib::Database.instance_variable_get(name_procs_var)[unique_key] = name
          end
      
          AstiLib::Database.instance_variable_set(:@name, name)
        end

        if handle_description
          description_value = data[:description] || data[:desc]
          unless description_value.nil? || description_value.is_a?(String) || description_value.is_a?(Proc)
            raise "ERROR: `description` must be a String or Proc, but got #{description_value.class}."
          end
      
          description = data.fetch(:description, data.fetch(:desc, defaults[:description]))
      
          # If description is a Proc, store it for later use
          if description.is_a?(Proc)
            AstiLib::Database.instance_variable_get(description_procs_var)[unique_key] = description
          end
      
          AstiLib::Database.instance_variable_set(:@description, description)
        end

        if handle_icon
          # Support both :icon and :icon_index
          icon_value = data[:icon] || data[:icon_index]
          unless icon_value.nil? || icon_value.is_a?(Integer)
            raise "ERROR: `icon` must be an Integer, but got #{icon_value.class}."
          end
          icon = data.fetch(:icon, data.fetch(:icon_index, defaults[:icon]))
          AstiLib::Database.instance_variable_set(:@icon, icon)
        end

        if handle_note
          note_value = data[:note]
          unless note_value.nil? || note_value.is_a?(String)
            raise "ERROR: `note` must be a String, but got #{note_value.class}."
          end
          note = data.fetch(:note, defaults[:note])
          AstiLib::Database.instance_variable_set(:@note, note)
        end
      end

      # Handles the attribues if the arguments for the object's data was given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, unique_key, type, options = {})
        handle_name = options.fetch(:name, true)
        handle_description = options.fetch(:description, true)
        handle_icon = options.fetch(:icon, true)
        handle_note = options.fetch(:note, true)

        name_procs_var = "@#{type}_name_procs"
        description_procs_var = "@#{type}_description_procs"

        if handle_name
          name_value = args[argument_indexes[:name]]
          unless name_value.nil? || name_value.is_a?(String) || name_value.is_a?(Proc)
            raise "ERROR: `name` must be a String or Proc, but got #{name_value.class}."
          end
      
          name = args[argument_indexes[:name]] || defaults[:name]
      
          # If name is a Proc, store it for later use
          if name.is_a?(Proc)
            AstiLib::Database.instance_variable_get(name_procs_var)[unique_key] = name
          end
      
          AstiLib::Database.instance_variable_set(:@name, name)
        end

        if handle_description
          description_value = args[argument_indexes[:description]]
          unless description_value.nil? || description_value.is_a?(String) || description_value.is_a?(Proc)
            raise "ERROR: `description` must be a String or Proc, but got #{description_value.class}."
          end
      
          description = args[argument_indexes[:description]] || defaults[:description]
      
          # If description is a Proc, store it for later use
          if description.is_a?(Proc)
            AstiLib::Database.instance_variable_get(description_procs_var)[unique_key] = description
          end
      
          AstiLib::Database.instance_variable_set(:@description, description)
        end

        if handle_icon
          icon_value = args[argument_indexes[:icon]]
          unless icon_value.nil? || icon_value.is_a?(Integer)
            raise "ERROR: `icon` must be an Integer, but got #{icon_value.class}."
          end
          icon = args[argument_indexes[:icon]] || defaults[:icon]
          AstiLib::Database.instance_variable_set(:@icon, icon)
        end

        if handle_note
          note_value = args[argument_indexes[:note]]
          unless note_value.nil? || note_value.is_a?(String)
            raise "ERROR: `note` must be a String, but got #{note_value.class}."
          end
          note = args[argument_indexes[:note]] || defaults[:note]
          AstiLib::Database.instance_variable_set(:@note, note)
        end
      end
    end

    # # Actor Attributes
    # ------------------
    # This module contains methods for handling the attributes of the `RPG::Actor` class.
    module ActorAttributes
      # Handles the attributes if the arguments for the actor's data were given as a Hash
      def self.handle_attributes_hash(data, defaults, unique_key, options = {})
        handle_nickname = options.fetch(:nickname, true)
        handle_class = options.fetch(:class, true)
        handle_initial_level = options.fetch(:initial_level, true)
        handle_max_level = options.fetch(:max_level, true)
        handle_character_name = options.fetch(:character_name, true)
        handle_character_index = options.fetch(:character_index, true)
        handle_face_name = options.fetch(:face_name, true)
        handle_face_index = options.fetch(:face_index, true)
        handle_equips = options.fetch(:equips, true)
    
        if handle_nickname
          nickname_value = data[:nickname]
          unless nickname_value.nil? || nickname_value.is_a?(String) || nickname_value.is_a?(Proc)
            raise "ERROR: `nickname` must be a String or Proc, but got #{nickname_value.class}."
          end

          nickname = data.fetch(:nickname, defaults[:nickname])

          if nickname.is_a?(Proc)
            AstiLib::Database.instance_variable_get(:@actor_nickname_procs)[unique_key] = nickname
          end
          AstiLib::Database.instance_variable_set(:@nickname, nickname)
        end
    
        if handle_class
          class_value = data[:class] || data[:class_id]
          unless class_value.nil? || class_value.is_a?(Integer)
            raise "ERROR: `class` must be an Integer, but got #{class_value.class}."
          end
          class_id = class_value || defaults[:class]
          AstiLib::Database.instance_variable_set(:@class, class_id)
        end
    
        if handle_initial_level
          initial_level_value = data[:initial_level] || data[:level]
          unless initial_level_value.nil? || initial_level_value.is_a?(Integer)
            raise "ERROR: `initial_level` must be an Integer, but got #{initial_level_value.class}."
          end
          initial_level = initial_level_value || defaults[:initial_level]
          AstiLib::Database.instance_variable_set(:@initial_level, initial_level)
        end
    
        if handle_max_level
          max_level_value = data[:max_level]
          unless max_level_value.nil? || max_level_value.is_a?(Integer)
            raise "ERROR: `max_level` must be an Integer, but got #{max_level_value.class}."
          end
          max_level = max_level_value || defaults[:max_level]
          AstiLib::Database.instance_variable_set(:@max_level, max_level)
        end

        if handle_character_name
          character_name_value = data[:character_name]
          unless character_name_value.nil? || character_name_value.is_a?(String)
            raise "ERROR: `character_name` must be a String, but got #{character_name_value.class}."
          end
          character_name = character_name_value || defaults[:character_name]
          AstiLib::Database.instance_variable_set(:@character_name, character_name)
        end
        
        if handle_character_index
          character_index_value = data[:character_index]
          unless character_index_value.nil? || character_index_value.is_a?(Integer)
            raise "ERROR: `character_index` must be an Integer, but got #{character_index_value.class}."
          end
          character_index = character_index_value || defaults[:character_index]
          AstiLib::Database.instance_variable_set(:@character_index, character_index)
        end
        
        if handle_face_name
          face_name_value = data[:face_name]
          unless face_name_value.nil? || face_name_value.is_a?(String)
            raise "ERROR: `face_name` must be a String, but got #{face_name_value.class}."
          end
          face_name = face_name_value || defaults[:face_name]
          AstiLib::Database.instance_variable_set(:@face_name, face_name)
        end
        
        if handle_face_index
          face_index_value = data[:face_index]
          unless face_index_value.nil? || face_index_value.is_a?(Integer)
            raise "ERROR: `face_index` must be an Integer, but got #{face_index_value.class}."
          end
          face_index = face_index_value || defaults[:face_index]
          AstiLib::Database.instance_variable_set(:@face_index, face_index)
        end

        if handle_equips
          equips_value = data[:equips]
          unless equips_value.nil? || (equips_value.is_a?(Array) && equips_value.length == 5 && equips_value.all? { |e| e.is_a?(Integer) })
            raise "ERROR: `equips` must be an Array of 5 Integers."
          end
          equips = equips_value || defaults[:equips]
          AstiLib::Database.instance_variable_set(:@equips, equips)
        end
      end
    
      # Handles the attributes if the arguments for the actor's data were given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, unique_key, options = {})
        handle_nickname = options.fetch(:nickname, true)
        handle_class = options.fetch(:class, true)
        handle_initial_level = options.fetch(:initial_level, true)
        handle_max_level = options.fetch(:max_level, true)
        handle_character_name = options.fetch(:character_name, true)
        handle_character_index = options.fetch(:character_index, true)
        handle_face_name = options.fetch(:face_name, true)
        handle_face_index = options.fetch(:face_index, true)
        handle_equips = options.fetch(:equips, true)
    
        if handle_nickname
          nickname_value = args[argument_indexes[:nickname]]
          unless nickname_value.nil? || nickname_value.is_a?(String) || nickname_value.is_a?(Proc)
            raise "ERROR: `nickname` must be a String or Proc, but got #{nickname_value.class}."
          end
          nickname = nickname_value || defaults[:nickname]
          if nickname.is_a?(Proc)
            AstiLib::Database.instance_variable_get(:@actor_nickname_procs)[unique_key] = nickname
          end
          AstiLib::Database.instance_variable_set(:@nickname, nickname)
        end
    
        if handle_class
          class_value = args[argument_indexes[:class]]
          unless class_value.nil? || class_value.is_a?(Integer)
            raise "ERROR: `class` must be an Integer, but got #{class_value.class}."
          end
          class_id = class_value || defaults[:class]
          AstiLib::Database.instance_variable_set(:@class, class_id)
        end
    
        if handle_initial_level
          initial_level_value = args[argument_indexes[:initial_level]]
          unless initial_level_value.nil? || initial_level_value.is_a?(Integer)
            raise "ERROR: `initial_level` must be an Integer, but got #{initial_level_value.class}."
          end
          initial_level = initial_level_value || defaults[:initial_level]
          AstiLib::Database.instance_variable_set(:@initial_level, initial_level)
        end
    
        if handle_max_level
          max_level_value = args[argument_indexes[:max_level]]
          unless max_level_value.nil? || max_level_value.is_a?(Integer)
            raise "ERROR: `max_level` must be an Integer, but got #{max_level_value.class}."
          end
          max_level = max_level_value || defaults[:max_level]
          AstiLib::Database.instance_variable_set(:@max_level, max_level)
        end

        if handle_character_name
          character_name_value = args[argument_indexes[:character_name]]
          unless character_name_value.nil? || character_name_value.is_a?(String)
            raise "ERROR: `character_name` must be a String, but got #{character_name_value.class}."
          end
          character_name = character_name_value || defaults[:character_name]
          AstiLib::Database.instance_variable_set(:@character_name, character_name)
        end
        
        if handle_character_index
          character_index_value = args[argument_indexes[:character_index]]
          unless character_index_value.nil? || character_index_value.is_a?(Integer)
            raise "ERROR: `character_index` must be an Integer, but got #{character_index_value.class}."
          end
          character_index = character_index_value || defaults[:character_index]
          AstiLib::Database.instance_variable_set(:@character_index, character_index)
        end
        
        if handle_face_name
          face_name_value = args[argument_indexes[:face_name]]
          unless face_name_value.nil? || face_name_value.is_a?(String)
            raise "ERROR: `face_name` must be a String, but got #{face_name_value.class}."
          end
          face_name = face_name_value || defaults[:face_name]
          AstiLib::Database.instance_variable_set(:@face_name, face_name)
        end
        
        if handle_face_index
          face_index_value = args[argument_indexes[:face_index]]
          unless face_index_value.nil? || face_index_value.is_a?(Integer)
            raise "ERROR: `face_index` must be an Integer, but got #{face_index_value.class}."
          end
          face_index = face_index_value || defaults[:face_index]
          AstiLib::Database.instance_variable_set(:@face_index, face_index)
        end

        if handle_equips
          equips_value = args[argument_indexes[:equips]]
          unless equips_value.nil? || (equips_value.is_a?(Array) && equips_value.length == 5 && equips_value.all? { |e| e.is_a?(Integer) })
            raise "ERROR: `equips` must be an Array of 5 Integers."
          end
          equips = equips_value || defaults[:equips]
          AstiLib::Database.instance_variable_set(:@equips, equips)
        end
      end
    end

    # # Class Attributes
    # ------------------
    # This module contains methods for handling the attributes of the `RPG::Class` class.
    module ClassAttributes
      # Handles the attributes when the object's data is provided as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_exp_curve = options.fetch(:exp_curve, true)
        handle_param_curve = options.fetch(:parameter_curve, true)

        if handle_exp_curve
          exp_curve_value = data[:exp_curve] || data[:exp_parameter] || data[:exp_param]
          unless exp_curve_value.nil? || (exp_curve_value.is_a?(Array) && exp_curve_value.length == 4 && exp_curve_value.all? { |p| p.is_a?(Integer) })
            raise "ERROR: `exp_curve` must be an Array of 4 Integers, but got #{exp_curve_value.class}."
          end
          exp_curve = exp_curve_value || defaults[:exp_curve]
          AstiLib::Database.instance_variable_set(:@exp_curve, exp_curve)
        end
        
        if handle_param_curve
          param_curve_value = data[:parameter_curves] || data[:param_curves] || data[:params]
          unless param_curve_value.nil? || param_curve_value.is_a?(Table)
            raise "ERROR: `parameter_curve` must be a Table, but got #{param_curve_value.class}."
          end
          param_curve = param_curve_value || defaults[:parameter_curve]
          AstiLib::Database.instance_variable_set(:@param_curves, param_curve)
        end
      end
    
      # Handles the attributes when the object's data is provided as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_exp_curve = options.fetch(:exp_curve, true)
        handle_param_curve = options.fetch(:parameter_curve, true)
    
        if handle_exp_curve
          exp_curve_value = args[argument_indexes[:exp_curve]]
          unless exp_curve_value.nil? || (exp_curve_value.is_a?(Array) && exp_curve_value.length == 4 && exp_curve_value.all? { |p| p.is_a?(Integer) })
            raise "ERROR: `exp_curve` must be an Array of 4 Integers, but got #{exp_curve_value.class}."
          end
          exp_curve = exp_curve_value || defaults[:exp_curve]
          AstiLib::Database.instance_variable_set(:@exp_curve, exp_curve)
        end

        if handle_param_curve
          param_curve_value = args[argument_indexes[:parameter_curve]]
          unless param_curve_value.nil? || param_curve_value.is_a?(Table)
            raise "ERROR: `parameter_curve` must be a Table, but got #{param_curve_value.class}."
          end
          param_curve = param_curve_value || defaults[:parameter_curve]
          AstiLib::Database.instance_variable_set(:@param_curve, param_curve)
        end
      end
    end

    # # Usable Item Attributes
    # ------------------------
    # This module contains methods for handling the attributes of the `RPG::UsableItem` class.
    module UsableItemAttributes

      # Handles the attributes when the object's data is given as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_scope = options.fetch(:scope, true)
        handle_occasion = options.fetch(:occasion, true)
        handle_speed = options.fetch(:speed, true)
        handle_success_rate = options.fetch(:success_rate, true)
        handle_repeats = options.fetch(:repeats, true)
        handle_tp_gain = options.fetch(:tp_gain, true)
        handle_hit_type = options.fetch(:hit_type, true)
        handle_animation = options.fetch(:animation, true)
    
        if handle_scope
          scope_value = data[:scope]
          if scope_value.is_a?(Symbol)
            unless SCOPE_SYMBOLS.key?(scope_value)
              raise "ERROR: Invalid scope symbol: #{scope_value}. It does not exist in SCOPE_SYMBOLS."
            end
            scope_value = SCOPE_SYMBOLS[scope_value]
          elsif !scope_value.is_a?(Integer) && !scope_value.nil?
            raise "ERROR: `scope` must be an Integer or a valid Symbol, but got #{scope_value.class}."
          end
          scope = scope_value || defaults[:scope]
          AstiLib::Database.instance_variable_set(:@scope, scope)
        end
    
        if handle_occasion
          occasion_value = data[:occasion]
          if occasion_value.is_a?(Symbol)
            unless OCCASION_SYMBOLS.key?(occasion_value)
              raise "ERROR: Invalid occasion symbol: #{occasion_value}. It does not exist in OCCASION_SYMBOLS."
            end
            occasion_value = OCCASION_SYMBOLS[occasion_value]
          elsif !occasion_value.is_a?(Integer) && !occasion_value.nil?
            raise "ERROR: `occasion` must be an Integer or a valid Symbol, but got #{occasion_value.class}."
          end
          occasion = occasion_value || defaults[:occasion]
          AstiLib::Database.instance_variable_set(:@occasion, occasion)
        end
    
        if handle_speed
          speed_value = data[:speed]
          unless speed_value.nil? || speed_value.is_a?(Integer)
            raise "ERROR: `speed` must be an Integer, but got #{speed_value.class}."
          end
          speed = speed_value || defaults[:speed]
          AstiLib::Database.instance_variable_set(:@speed, speed)
        end
    
        if handle_success_rate
          success_rate_value = data[:success_rate]
          unless success_rate_value.nil? || success_rate_value.is_a?(Integer)
            raise "ERROR: `success_rate` must be an Integer, but got #{success_rate_value.class}."
          end
          success_rate = success_rate_value || defaults[:success_rate]
          AstiLib::Database.instance_variable_set(:@success_rate, success_rate)
        end
    
        if handle_repeats
          repeats_value = data[:repeats]
          unless repeats_value.nil? || repeats_value.is_a?(Integer)
            raise "ERROR: `repeats` must be an Integer, but got #{repeats_value.class}."
          end
          repeats = repeats_value || defaults[:repeats]
          AstiLib::Database.instance_variable_set(:@repeats, repeats)
        end
    
        if handle_tp_gain
          tp_gain_value = data[:tp_gain]
          unless tp_gain_value.nil? || tp_gain_value.is_a?(Integer)
            raise "ERROR: `tp_gain` must be an Integer, but got #{tp_gain_value.class}."
          end
          tp_gain = tp_gain_value || defaults[:tp_gain]
          AstiLib::Database.instance_variable_set(:@tp_gain, tp_gain)
        end
    
        if handle_hit_type
          hit_type_value = data[:hit_type]
          if hit_type_value.is_a?(Symbol)
            unless HIT_TYPE_SYMBOLS.key?(hit_type_value)
              raise "ERROR: Invalid hit type symbol: #{hit_type_value}. It does not exist in HIT_TYPE_SYMBOLS."
            end
            hit_type_value = HIT_TYPE_SYMBOLS[hit_type_value]
          elsif !hit_type_value.is_a?(Integer) && !hit_type_value.nil?
            raise "ERROR: `hit_type` must be an Integer or a valid Symbol, but got #{hit_type_value.class}."
          end
          hit_type = hit_type_value || defaults[:hit_type]
          AstiLib::Database.instance_variable_set(:@hit_type, hit_type)
        end
    
        if handle_animation
          animation_value = data[:animation]
          unless animation_value.nil? || animation_value.is_a?(Integer)
            raise "ERROR: `animation` must be an Integer, but got #{animation_value.class}."
          end
          animation = animation_value || defaults[:animation]
          AstiLib::Database.instance_variable_set(:@animation, animation)
        end
      end

      # Handles the attributes when the object's data is given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_scope = options.fetch(:scope, true)
        handle_occasion = options.fetch(:occasion, true)
        handle_speed = options.fetch(:speed, true)
        handle_success_rate = options.fetch(:success_rate, true)
        handle_repeats = options.fetch(:repeats, true)
        handle_tp_gain = options.fetch(:tp_gain, true)
        handle_hit_type = options.fetch(:hit_type, true)
        handle_animation = options.fetch(:animation, true)

        if handle_scope
          scope_value = args[argument_indexes[:scope]]
          if scope_value.is_a?(Symbol)
            unless SCOPE_SYMBOLS.key?(scope_value)
              raise "ERROR: Invalid scope symbol: #{scope_value}. It does not exist in SCOPE_SYMBOLS."
            end
            scope_value = SCOPE_SYMBOLS[scope_value]
          elsif !scope_value.is_a?(Integer) && !scope_value.nil?
            raise "ERROR: `scope` must be an Integer or a valid Symbol, but got #{scope_value.class}."
          end
          scope = scope_value || defaults[:scope]
          AstiLib::Database.instance_variable_set(:@scope, scope)
        end
        
        if handle_occasion
          occasion_value = args[argument_indexes[:occasion]]
          if occasion_value.is_a?(Symbol)
            unless OCCASION_SYMBOLS.key?(occasion_value)
              raise "ERROR: Invalid occasion symbol: #{occasion_value}. It does not exist in OCCASION_SYMBOLS."
            end
            occasion_value = OCCASION_SYMBOLS[occasion_value]
          elsif !occasion_value.is_a?(Integer) && !occasion_value.nil?
            raise "ERROR: `occasion` must be an Integer or a valid Symbol, but got #{occasion_value.class}."
          end
          occasion = occasion_value || defaults[:occasion]
          AstiLib::Database.instance_variable_set(:@occasion, occasion)
        end
        
        if handle_speed
          speed_value = args[argument_indexes[:speed]]
          unless speed_value.nil? || speed_value.is_a?(Integer)
            raise "ERROR: `speed` must be an Integer, but got #{speed_value.class}."
          end
          speed = speed_value || defaults[:speed]
          AstiLib::Database.instance_variable_set(:@speed, speed)
        end
        
        if handle_success_rate
          success_rate_value = args[argument_indexes[:success_rate]]
          unless success_rate_value.nil? || success_rate_value.is_a?(Integer)
            raise "ERROR: `success_rate` must be an Integer, but got #{success_rate_value.class}."
          end
          success_rate = success_rate_value || defaults[:success_rate]
          AstiLib::Database.instance_variable_set(:@success_rate, success_rate)
        end
        
        if handle_repeats
          repeats_value = args[argument_indexes[:repeats]]
          unless repeats_value.nil? || repeats_value.is_a?(Integer)
            raise "ERROR: `repeats` must be an Integer, but got #{repeats_value.class}."
          end
          repeats = repeats_value || defaults[:repeats]
          AstiLib::Database.instance_variable_set(:@repeats, repeats)
        end
        
        if handle_tp_gain
          tp_gain_value = args[argument_indexes[:tp_gain]]
          unless tp_gain_value.nil? || tp_gain_value.is_a?(Integer)
            raise "ERROR: `tp_gain` must be an Integer, but got #{tp_gain_value.class}."
          end
          tp_gain = tp_gain_value || defaults[:tp_gain]
          AstiLib::Database.instance_variable_set(:@tp_gain, tp_gain)
        end
        
        if handle_hit_type
          hit_type_value = args[argument_indexes[:hit_type]]
          if hit_type_value.is_a?(Symbol)
            unless HIT_TYPE_SYMBOLS.key?(hit_type_value)
              raise "ERROR: Invalid hit type symbol: #{hit_type_value}. It does not exist in HIT_TYPE_SYMBOLS."
            end
            hit_type_value = HIT_TYPE_SYMBOLS[hit_type_value]
          elsif !hit_type_value.is_a?(Integer) && !hit_type_value.nil?
            raise "ERROR: `hit_type` must be an Integer or a valid Symbol, but got #{hit_type_value.class}."
          end
          hit_type = hit_type_value || defaults[:hit_type]
          AstiLib::Database.instance_variable_set(:@hit_type, hit_type)
        end
        
        if handle_animation
          animation_value = args[argument_indexes[:animation]]
          unless animation_value.nil? || animation_value.is_a?(Integer)
            raise "ERROR: `animation` must be an Integer, but got #{animation_value.class}."
          end
          animation = animation_value || defaults[:animation]
          AstiLib::Database.instance_variable_set(:@animation, animation)
        end
      end
    end

    # # Damage Attributes
    # -------------------
    # This module contains methods for handling the attributes of the `RPG::UsableItem::Damage` class.
    module DamageAttributes
      # Handles the attributes when the object's data is given as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_damage_type = options.fetch(:damage_type, true)
        handle_damage_element = options.fetch(:damage_element, true)
        handle_formula = options.fetch(:formula, true)
        handle_variance = options.fetch(:variance, true)
        handle_critical = options.fetch(:critical, true)
    
        if handle_damage_type
          damage_type_value = data[:damage_type] || data[:damage]
          if damage_type_value.is_a?(Symbol)
            unless DAMAGE_TYPE_SYMBOLS.key?(damage_type_value)
              raise "ERROR: Invalid damage type symbol: #{damage_type_value}. It does not exist in DAMAGE_TYPE_SYMBOLS."
            end
            damage_type_value = DAMAGE_TYPE_SYMBOLS[damage_type_value]
          elsif !damage_type_value.is_a?(Integer) && !damage_type_value.nil?
            raise "ERROR: `damage_type` must be an Integer or a valid Symbol, but got #{damage_type_value.class}."
          end
          damage_type = damage_type_value || defaults[:damage_type]
          AstiLib::Database.instance_variable_set(:@damage_type, damage_type)
        end
    
        if handle_damage_element
          damage_element_value = data[:damage_element] || data[:element]
          if damage_element_value.is_a?(Symbol)
            unless ELEMENT_SYMBOLS.key?(damage_element_value)
              raise "ERROR: Invalid element symbol: #{damage_element_value}. It does not exist in ELEMENT_SYMBOLS."
            end
            damage_element_value = ELEMENT_SYMBOLS[damage_element_value]
          elsif !damage_element_value.is_a?(Integer) && !damage_element_value.nil?
            raise "ERROR: `damage_element` must be an Integer or a valid Symbol, but got #{damage_element_value.class}."
          end
          damage_element = damage_element_value || defaults[:damage_element]
          AstiLib::Database.instance_variable_set(:@damage_element, damage_element)
        end
    
        if handle_formula
          formula_value = data[:formula] || data[:damage_formula]
          unless formula_value.nil? || formula_value.is_a?(String)
            raise "ERROR: `formula` must be a String, but got #{formula_value.class}."
          end
          formula = formula_value || defaults[:formula]
          AstiLib::Database.instance_variable_set(:@formula, formula)
        end
    
        if handle_variance
          variance_value = data[:variance] || data[:damage_variance]
          unless variance_value.nil? || variance_value.is_a?(Integer)
            raise "ERROR: `variance` must be an Integer, but got #{variance_value.class}."
          end
          variance = variance_value || defaults[:variance]
          AstiLib::Database.instance_variable_set(:@variance, variance)
        end
    
        if handle_critical
          critical_value = data[:critical] || data[:can_crit]
          unless !!critical_value == critical_value # Checks if it's a boolean
            raise "ERROR: `critical` must be a Boolean, but got #{critical_value.class}."
          end
          critical = critical_value.nil? ? defaults[:critical] : critical_value
          AstiLib::Database.instance_variable_set(:@critical, critical)
        end
      end
    
      # Handles the attributes when the object's data is given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_damage_type = options.fetch(:damage_type, true)
        handle_damage_element = options.fetch(:damage_element, true)
        handle_formula = options.fetch(:formula, true)
        handle_variance = options.fetch(:variance, true)
        handle_critical = options.fetch(:critical, true)
    
        if handle_damage_type
          damage_type_value = args[argument_indexes[:damage_type]]
          if damage_type_value.is_a?(Symbol)
            unless DAMAGE_TYPE_SYMBOLS.key?(damage_type_value)
              raise "ERROR: Invalid damage type symbol: #{damage_type_value}. It does not exist in DAMAGE_TYPE_SYMBOLS."
            end
            damage_type_value = DAMAGE_TYPE_SYMBOLS[damage_type_value]
          elsif !damage_type_value.is_a?(Integer) && !damage_type_value.nil?
            raise "ERROR: `damage_type` must be an Integer or a valid Symbol, but got #{damage_type_value.class}."
          end
          damage_type = damage_type_value || defaults[:damage_type]
          AstiLib::Database.instance_variable_set(:@damage_type, damage_type)
        end
    
        if handle_damage_element
          damage_element_value = args[argument_indexes[:damage_element]]
          if damage_element_value.is_a?(Symbol)
            unless ELEMENT_SYMBOLS.key?(damage_element_value)
              raise "ERROR: Invalid element symbol: #{damage_element_value}. It does not exist in ELEMENT_SYMBOLS."
            end
            damage_element_value = ELEMENT_SYMBOLS[damage_element_value]
          elsif !damage_element_value.is_a?(Integer) && !damage_element_value.nil?
            raise "ERROR: `damage_element` must be an Integer or a valid Symbol, but got #{damage_element_value.class}."
          end
          damage_element = damage_element_value || defaults[:damage_element]
          AstiLib::Database.instance_variable_set(:@damage_element, damage_element)
        end
    
        if handle_formula
          formula_value = args[argument_indexes[:formula]]
          unless formula_value.nil? || formula_value.is_a?(String)
            raise "ERROR: `formula` must be a String, but got #{formula_value.class}."
          end
          formula = formula_value || defaults[:formula]
          AstiLib::Database.instance_variable_set(:@formula, formula)
        end
    
        if handle_variance
          variance_value = args[argument_indexes[:variance]]
          unless variance_value.nil? || variance_value.is_a?(Integer)
            raise "ERROR: `variance` must be an Integer, but got #{variance_value.class}."
          end
          variance = variance_value || defaults[:variance]
          AstiLib::Database.instance_variable_set(:@variance, variance)
        end
    
        if handle_critical
          critical_value = args[argument_indexes[:critical]]
          unless !!critical_value == critical_value # Checks if it's a boolean
            raise "ERROR: `critical` must be a Boolean, but got #{critical_value.class}."
          end
          critical = critical_value.nil? ? defaults[:critical] : critical_value
          AstiLib::Database.instance_variable_set(:@critical, critical)
        end
      end
    end

    # # Skill Attributes
    # ------------------
    # This module contains methods for handling the attributes of the `RPG::Skill` class.
    module SkillAttributes
      # Handles the attributes when the object's data is given as a Hash
      def self.handle_attributes_hash(data, defaults, unique_key, options = {})
        handle_skill_type = options.fetch(:skill_type, true)
        handle_mp_cost = options.fetch(:mp_cost, true)
        handle_tp_cost = options.fetch(:tp_cost, true)
        handle_message1 = options.fetch(:message1, true)
        handle_message2 = options.fetch(:message2, true)
        handle_weapon_type1 = options.fetch(:weapon_type1, true)
        handle_weapon_type2 = options.fetch(:weapon_type2, true)
    
        if handle_skill_type
          skill_type_value = data[:skill_type] || data[:skill_type_id] || data[:stype_id]
          if skill_type_value.is_a?(Symbol)
            unless SKILL_TYPE_SYMBOLS.key?(skill_type_value)
              raise "ERROR: Invalid skill type symbol: #{skill_type_value}. It does not exist in SKILL_TYPE_SYMBOLS."
            end
            skill_type_value = SKILL_TYPE_SYMBOLS[skill_type_value]
          elsif !skill_type_value.is_a?(Integer) && !skill_type_value.nil?
            raise "ERROR: `skill_type` must be an Integer or a valid Symbol, but got #{skill_type_value.class}."
          end
          skill_type = skill_type_value || defaults[:skill_type]
          AstiLib::Database.instance_variable_set(:@skill_type, skill_type)
        end
    
        if handle_mp_cost
          mp_cost_value = data[:mp_cost]
          unless mp_cost_value.nil? || mp_cost_value.is_a?(Integer)
            raise "ERROR: `mp_cost` must be an Integer, but got #{mp_cost_value.class}."
          end
          mp_cost = mp_cost_value || defaults[:mp_cost]
          AstiLib::Database.instance_variable_set(:@mp_cost, mp_cost)
        end
    
        if handle_tp_cost
          tp_cost_value = data[:tp_cost]
          unless tp_cost_value.nil? || tp_cost_value.is_a?(Integer)
            raise "ERROR: `tp_cost` must be an Integer, but got #{tp_cost_value.class}."
          end
          tp_cost = tp_cost_value || defaults[:tp_cost]
          AstiLib::Database.instance_variable_set(:@tp_cost, tp_cost)
        end
    
        if handle_message1
          message1_value = data[:message1]
          unless message1_value.nil? || message1_value.is_a?(String) || message1_value.is_a?(Proc)
            raise "ERROR: `message1` must be a String or Proc, but got #{message1_value.class}."
          end
        
          message1 = data.fetch(:message1, defaults[:message1])
        
          if message1.is_a?(Proc)
            AstiLib::Database.instance_variable_get(:@message1_procs)[unique_key] = message1
          end
          AstiLib::Database.instance_variable_set(:@message1, message1)
        end
        
        if handle_message2
          message2_value = data[:message2]
          unless message2_value.nil? || message2_value.is_a?(String) || message2_value.is_a?(Proc)
            raise "ERROR: `message2` must be a String or Proc, but got #{message2_value.class}."
          end
        
          message2 = data.fetch(:message2, defaults[:message2])
        
          if message2.is_a?(Proc)
            AstiLib::Database.instance_variable_get(:@message2_procs)[unique_key] = message2
          end
          AstiLib::Database.instance_variable_set(:@message2, message2)
        end
    
        if handle_weapon_type1
          weapon_type1_value = data[:required_weapon_type1] || data[:weapon_type1] || data[:required_wtype_id1]
          if weapon_type1_value.is_a?(Symbol)
            unless WEAPON_TYPE_SYMBOLS.key?(weapon_type1_value)
              raise "ERROR: Invalid weapon type symbol: #{weapon_type1_value}. It does not exist in WEAPON_TYPE_SYMBOLS."
            end
            weapon_type1_value = WEAPON_TYPE_SYMBOLS[weapon_type1_value]
          elsif !weapon_type1_value.is_a?(Integer) && !weapon_type1_value.nil?
            raise "ERROR: `weapon_type1` must be an Integer or a valid Symbol, but got #{weapon_type1_value.class}."
          end
          weapon_type1 = weapon_type1_value || defaults[:required_weapon_type1]
          AstiLib::Database.instance_variable_set(:@required_weapon_type1, weapon_type1)
        end
    
        if handle_weapon_type2
          weapon_type2_value = data[:required_weapon_type2] || data[:weapon_type2] || data[:required_wtype_id2]
          if weapon_type2_value.is_a?(Symbol)
            unless WEAPON_TYPE_SYMBOLS.key?(weapon_type2_value)
              raise "ERROR: Invalid weapon type symbol: #{weapon_type2_value}. It does not exist in WEAPON_TYPE_SYMBOLS."
            end
            weapon_type2_value = WEAPON_TYPE_SYMBOLS[weapon_type2_value]
          elsif !weapon_type2_value.is_a?(Integer) && !weapon_type2_value.nil?
            raise "ERROR: `weapon_type2` must be an Integer or a valid Symbol, but got #{weapon_type2_value.class}."
          end
          weapon_type2 = weapon_type2_value || defaults[:required_weapon_type2]
          AstiLib::Database.instance_variable_set(:@required_weapon_type2, weapon_type2)
        end
      end
    
      # Handles the attributes when the object's data is given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, unique_key, options = {})
        handle_skill_type = options.fetch(:skill_type, true)
        handle_mp_cost = options.fetch(:mp_cost, true)
        handle_tp_cost = options.fetch(:tp_cost, true)
        handle_message1 = options.fetch(:message1, true)
        handle_message2 = options.fetch(:message2, true)
        handle_weapon_type1 = options.fetch(:weapon_type1, true)
        handle_weapon_type2 = options.fetch(:weapon_type2, true)
    
        if handle_skill_type
          skill_type_value = args[argument_indexes[:skill_type]]
          if skill_type_value.is_a?(Symbol)
            unless SKILL_TYPE_SYMBOLS.key?(skill_type_value)
              raise "ERROR: Invalid skill type symbol: #{skill_type_value}. It does not exist in SKILL_TYPE_SYMBOLS."
            end
            skill_type_value = SKILL_TYPE_SYMBOLS[skill_type_value]
          elsif !skill_type_value.is_a?(Integer) && !skill_type_value.nil?
            raise "ERROR: `skill_type` must be an Integer or a valid Symbol, but got #{skill_type_value.class}."
          end
          skill_type = skill_type_value || defaults[:skill_type]
          AstiLib::Database.instance_variable_set(:@skill_type, skill_type)
        end
    
        if handle_mp_cost
          mp_cost_value = args[argument_indexes[:mp_cost]]
          unless mp_cost_value.nil? || mp_cost_value.is_a?(Integer)
            raise "ERROR: `mp_cost` must be an Integer, but got #{mp_cost_value.class}."
          end
          mp_cost = mp_cost_value || defaults[:mp_cost]
          AstiLib::Database.instance_variable_set(:@mp_cost, mp_cost)
        end
    
        if handle_tp_cost
          tp_cost_value = args[argument_indexes[:tp_cost]]
          unless tp_cost_value.nil? || tp_cost_value.is_a?(Integer)
            raise "ERROR: `tp_cost` must be an Integer, but got #{tp_cost_value.class}."
          end
          tp_cost = tp_cost_value || defaults[:tp_cost]
          AstiLib::Database.instance_variable_set(:@tp_cost, tp_cost)
        end
    
        if handle_message1
          message1_value = args[argument_indexes[:message1]]
          unless message1_value.nil? || message1_value.is_a?(String) || message1_value.is_a?(Proc)
            raise "ERROR: `message1` must be a String or Proc, but got #{message1_value.class}."
          end
        
          message1 = message1_value || defaults[:message1]
        
          if message1.is_a?(Proc)
            AstiLib::Database.instance_variable_get(:@message1_procs)[unique_key] = message1
          end
          AstiLib::Database.instance_variable_set(:@message1, message1)
        end
        
        if handle_message2
          message2_value = args[argument_indexes[:message2]]
          unless message2_value.nil? || message2_value.is_a?(String) || message2_value.is_a?(Proc)
            raise "ERROR: `message2` must be a String or Proc, but got #{message2_value.class}."
          end
        
          message2 = message2_value || defaults[:message2]
        
          if message2.is_a?(Proc)
            AstiLib::Database.instance_variable_get(:@message2_procs)[unique_key] = message2
          end
          AstiLib::Database.instance_variable_set(:@message2, message2)
        end
    
        if handle_weapon_type1
          weapon_type1_value = args[argument_indexes[:weapon_type1]]
          if weapon_type1_value.is_a?(Symbol)
            unless WEAPON_TYPE_SYMBOLS.key?(weapon_type1_value)
              raise "ERROR: Invalid weapon type symbol: #{weapon_type1_value}. It does not exist in WEAPON_TYPE_SYMBOLS."
            end
            weapon_type1_value = WEAPON_TYPE_SYMBOLS[weapon_type1_value]
          elsif !weapon_type1_value.is_a?(Integer) && !weapon_type1_value.nil?
            raise "ERROR: `weapon_type1` must be an Integer or a valid Symbol, but got #{weapon_type1_value.class}."
          end
          weapon_type1 = weapon_type1_value || defaults[:required_weapon_type1]
          AstiLib::Database.instance_variable_set(:@required_weapon_type1, weapon_type1)
        end
    
        if handle_weapon_type2
          weapon_type2_value = args[argument_indexes[:weapon_type2]]
          if weapon_type2_value.is_a?(Symbol)
            unless WEAPON_TYPE_SYMBOLS.key?(weapon_type2_value)
              raise "ERROR: Invalid weapon type symbol: #{weapon_type2_value}. It does not exist in WEAPON_TYPE_SYMBOLS."
            end
            weapon_type2_value = WEAPON_TYPE_SYMBOLS[weapon_type2_value]
          elsif !weapon_type2_value.is_a?(Integer) && !weapon_type2_value.nil?
            raise "ERROR: `weapon_type2` must be an Integer or a valid Symbol, but got #{weapon_type2_value.class}."
          end
          weapon_type2 = weapon_type2_value || defaults[:required_weapon_type2]
          AstiLib::Database.instance_variable_set(:@required_weapon_type2, weapon_type2)
        end
      end
    end

    # # Item Attributes
    # ------------------
    # This module contains methods for handling the attributes of the `RPG::Item` class.
    module ItemAttributes
      # Handles the attributes if the arguments for the object's data were provided as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_item_type = options.fetch(:item_type, true)
        handle_price = options.fetch(:price, true)
        handle_consumable = options.fetch(:consumable, true)
    
        if handle_item_type
          item_type_value = data[:item_type] || data[:item_type_id] || data[:itype_id]
          if item_type_value.is_a?(Symbol)
            if ITEM_TYPE_SYMBOLS.key?(item_type_value)
              item_type = ITEM_TYPE_SYMBOLS[item_type_value]
            else
              raise "ERROR: Invalid item type symbol: #{item_type_value}. It does not exist in ITEM_TYPE_SYMBOLS."
            end
          elsif !item_type_value.is_a?(Integer) && !item_type_value.nil?
            raise "ERROR: `item_type` must be an Integer or a valid Symbol, but got #{item_type_value.class}."
          else
            item_type = item_type_value || defaults[:item_type]
          end
          AstiLib::Database.instance_variable_set(:@item_type, item_type)
        end
    
        if handle_price
          price_value = data[:price]
          unless price_value.nil? || price_value.is_a?(Integer)
            raise "ERROR: `price` must be an Integer, but got #{price_value.class}."
          end
          price = data.fetch(:price, defaults[:price])
          AstiLib::Database.instance_variable_set(:@price, price)
        end
    
        if handle_consumable
          consumable_value = data[:consumable] || data[:consume]
          unless !!consumable_value == consumable_value || consumable_value.nil?
            raise "ERROR: `consumable` must be a Boolean, but got #{consumable_value.class}."
          end
          consumable = data.fetch(:consumable, defaults[:consumable])
          AstiLib::Database.instance_variable_set(:@consumable, consumable)
        end
      end
    
      # Handles the attributes if the arguments for the object's data were provided as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_item_type = options.fetch(:item_type, true)
        handle_price = options.fetch(:price, true)
        handle_consumable = options.fetch(:consumable, true)
    
        if handle_item_type
          item_type_value = args[argument_indexes[:item_type]]
          if item_type_value.is_a?(Symbol)
            if ITEM_TYPE_SYMBOLS.key?(item_type_value)
              item_type_value = ITEM_TYPE_SYMBOLS[item_type_value]
            else
              raise "ERROR: Invalid item type symbol: #{item_type_value}. It does not exist in ITEM_TYPE_SYMBOLS."
            end
          elsif !item_type_value.is_a?(Integer) && !item_type_value.nil?
            raise "ERROR: `item_type` must be an Integer or a valid Symbol, but got #{item_type_value.class}."
          end
          item_type = item_type_value || defaults[:item_type]
          AstiLib::Database.instance_variable_set(:@item_type, item_type)
        end
    
        if handle_price
          price_value = args[argument_indexes[:price]]
          unless price_value.nil? || price_value.is_a?(Integer)
            raise "ERROR: `price` must be an Integer, but got #{price_value.class}."
          end
          price = price_value || defaults[:price]
          AstiLib::Database.instance_variable_set(:@price, price)
        end
    
        if handle_consumable
          consumable_value = args[argument_indexes[:consumable]]
          unless !!consumable_value == consumable_value || consumable_value.nil?
            raise "ERROR: `consumable` must be a Boolean, but got #{consumable_value.class}."
          end
          consumable = consumable_value || defaults[:consumable]
          AstiLib::Database.instance_variable_set(:@consumable, consumable)
        end
      end
    end

    # # Equip Item Attributes
    # -----------------------
    # This module contains methods for handling the attributes of the `RPG::EquipItem` class.
    module EquipItemAttributes
      # Handles the attribues if the arguments for the object's data was given as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_price = options.fetch(:price, true)
        handle_equip_type = options.fetch(:equip_type, true)
        handle_parameters = options.fetch(:parameters, true)
    
        if handle_price
          price_value = data[:price]
          unless price_value.nil? || price_value.is_a?(Integer)
            raise "ERROR: `price` must be an Integer, but got #{price_value.class}."
          end
          price = data.fetch(:price, defaults[:price])
          AstiLib::Database.instance_variable_set(:@price, price)
        end
    
        if handle_equip_type
          equip_type_value = data[:equip_type] || data[:etype_id] || data[:etype]
          if equip_type_value.is_a?(Symbol)
            if EQUIP_TYPE_SYMBOLS.key?(equip_type_value)
              equip_type_value = EQUIP_TYPE_SYMBOLS[equip_type_value]
            else
              raise "ERROR: Invalid equip type symbol: #{equip_type_value}. It does not exist in EQUIP_TYPE_SYMBOLS."
            end
          elsif !equip_type_value.is_a?(Integer) && !equip_type_value.nil?
            raise "ERROR: `equip_type` must be an Integer or a valid Symbol, but got #{equip_type_value.class}."
          end
          equip_type = equip_type_value || defaults[:equip_type]
          AstiLib::Database.instance_variable_set(:@equip_type, equip_type)
        end
    
        if handle_parameters
          parameters_value = data[:parameters] || data[:params]
          parameters = handle_parameters_value(parameters_value) || defaults[:parameters]
          AstiLib::Database.instance_variable_set(:@parameters, parameters)
        end
      end

      # Handles the attribues if the arguments for the object's data was given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_price = options.fetch(:price, true)
        handle_equip_type = options.fetch(:equip_type, true)
        handle_parameters = options.fetch(:parameters, true)
    
        if handle_price
          price_value = args[argument_indexes[:price]]
          unless price_value.nil? || price_value.is_a?(Integer)
            raise "ERROR: `price` must be an Integer, but got #{price_value.class}."
          end
          price = args[argument_indexes[:price]] || defaults[:price]
          AstiLib::Database.instance_variable_set(:@price, price)
        end
    
        if handle_equip_type
          equip_type_value = args[argument_indexes[:equip_type]]
          if equip_type_value.is_a?(Symbol)
            if EQUIP_TYPE_SYMBOLS.key?(equip_type_value)
              equip_type_value = EQUIP_TYPE_SYMBOLS[equip_type_value]
            else
              raise "ERROR: Invalid equip type symbol: #{equip_type_value}. It does not exist in EQUIP_TYPE_SYMBOLS."
            end
          elsif !equip_type_value.is_a?(Integer) && !equip_type_value.nil?
            raise "ERROR: `equip_type` must be an Integer or a valid Symbol, but got #{equip_type_value.class}."
          end
          equip_type = equip_type_value || defaults[:equip_type]
          AstiLib::Database.instance_variable_set(:@equip_type, equip_type)
        end
    
        if handle_parameters
          parameters_value = args[argument_indexes[:parameters]]
          parameters = handle_parameters_value(parameters_value) || defaults[:parameters]
          AstiLib::Database.instance_variable_set(:@parameters, parameters)
        end
      end

      private

      class << self
        # Handles the parameters attribute
        def handle_parameters_value(parameters_value)
          if parameters_value.is_a?(Array)
            unless parameters_value.length == 8 && parameters_value.all? { |p| p.is_a?(Integer) }
              raise "ERROR: `parameters` must be an Array of 8 Integers."
            end
            parameters_value
          elsif parameters_value.is_a?(Hash)
            parameters_array = Array.new(8, 0)
            parameters_value.each do |key, value|
              index = PARAM_SYMBOLS[key]
              if index
                parameters_array[index] = value.is_a?(Integer) ? value : 0
              end
            end
            parameters_array
          elsif !parameters_value.nil?
            raise "ERROR: `parameters` must be an Array or Hash, but got #{parameters_value.class}."
          end
        end
      end
    end

    # # Weapon Attributes
    # -------------------
    # This module contains methods for handling the attributes of the `RPG::Weapon` class.
    module WeaponAttributes
      # Handles the attribues if the arguments for the object's data was given as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_weapon_type = options.fetch(:weapon_type, true)
        handle_animation = options.fetch(:animation, true)
    
        if handle_weapon_type
          weapon_type_value = data[:weapon_type] || data[:wtype_id] || data[:wtype]
          if weapon_type_value.is_a?(Symbol)
            if WEAPON_TYPE_SYMBOLS.key?(weapon_type_value)
              weapon_type = WEAPON_TYPE_SYMBOLS[weapon_type_value]
            else
              raise "ERROR: Invalid weapon type symbol: #{weapon_type_value}. It does not exist in WEAPON_TYPE_SYMBOLS."
            end
          elsif !weapon_type_value.is_a?(Integer) && !weapon_type_value.nil?
            raise "ERROR: `weapon_type` must be an Integer or a valid Symbol, but got #{weapon_type_value.class}."
          else
            weapon_type = weapon_type_value || defaults[:weapon_type]
          end
          AstiLib::Database.instance_variable_set(:@weapon_type, weapon_type)
        end
    
        if handle_animation
          animation_value = data[:animation] || data[:anim]
          unless animation_value.nil? || animation_value.is_a?(Integer)
            raise "ERROR: `animation` must be an Integer, but got #{animation_value.class}."
          end
          animation = data.fetch(:animation, defaults[:animation])
          AstiLib::Database.instance_variable_set(:@animation, animation)
        end
      end

      # Handles the attribues if the arguments for the object's data was given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_weapon_type = options.fetch(:weapon_type, true)
        handle_animation = options.fetch(:animation, true)
    
        if handle_weapon_type
          weapon_type_value = args[argument_indexes[:weapon_type]]
          if weapon_type_value.is_a?(Symbol)
            if WEAPON_TYPE_SYMBOLS.key?(weapon_type_value)
              weapon_type_value = WEAPON_TYPE_SYMBOLS[weapon_type_value]
            else
              raise "ERROR: Invalid weapon type symbol: #{weapon_type_value}. It does not exist in WEAPON_TYPE_SYMBOLS."
            end
          elsif !weapon_type_value.is_a?(Integer) && !weapon_type_value.nil?
            raise "ERROR: `weapon_type` must be an Integer or a valid Symbol, but got #{weapon_type_value.class}."
          end
          weapon_type = weapon_type_value || defaults[:weapon_type]
          AstiLib::Database.instance_variable_set(:@weapon_type, weapon_type)
        end
    
        if handle_animation
          animation_value = args[argument_indexes[:animation]]
          unless animation_value.nil? || animation_value.is_a?(Integer)
            raise "ERROR: `animation` must be an Integer, but got #{animation_value.class}."
          end
          animation = args[argument_indexes[:animation]] || defaults[:animation]
          AstiLib::Database.instance_variable_set(:@animation, animation)
        end
      end
    end

    # # Armor Attributes
    # ------------------
    # This module contains methods for handling the attributes of the `RPG::Armor` class.
    module ArmorAttributes
      # Handles the attribues if the arguments for the object's data was given as a Hash
      def self.handle_attributes_hash(data, defaults, options = {})
        handle_armor_type = options.fetch(:armor_type, true)
    
        if handle_armor_type
          armor_type_value = data[:armor_type] || data[:atype_id] || data[:atype]
          if armor_type_value.is_a?(Symbol)
            if ARMOR_TYPE_SYMBOLS.key?(armor_type_value)
              armor_type_value = ARMOR_TYPE_SYMBOLS[armor_type_value]
            else
              raise "ERROR: Invalid armor type symbol: #{armor_type_value}. It does not exist in ARMOR_TYPE_SYMBOLS."
            end
          elsif !armor_type_value.is_a?(Integer) && !armor_type_value.nil?
            raise "ERROR: `armor_type` must be an Integer or a valid Symbol, but got #{armor_type_value.class}."
          end
          armor_type = armor_type_value || defaults[:armor_type]
          AstiLib::Database.instance_variable_set(:@armor_type, armor_type)
        end
      end

      # Handles the attribues if the arguments for the object's data was given as multiple arguments
      def self.handle_attributes_args(args, argument_indexes, defaults, options = {})
        handle_armor_type = options.fetch(:armor_type, true)
    
        if handle_armor_type
          armor_type_value = args[argument_indexes[:armor_type]]
          if armor_type_value.is_a?(Symbol)
            if ARMOR_TYPE_SYMBOLS.key?(armor_type_value)
              armor_type_value = ARMOR_TYPE_SYMBOLS[armor_type_value]
            else
              raise "ERROR: Invalid armor type symbol: #{armor_type_value}. It does not exist in ARMOR_TYPE_SYMBOLS."
            end
          elsif !armor_type_value.is_a?(Integer) && !armor_type_value.nil?
            raise "ERROR: `armor_type` must be an Integer or a valid Symbol, but got #{armor_type_value.class}."
          end
          armor_type = armor_type_value || defaults[:armor_type]
          AstiLib::Database.instance_variable_set(:@armor_type, armor_type)
        end
      end
    end
  end
end