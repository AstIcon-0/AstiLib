module AstiLib
  module Database
    @class_name_procs = {}

    def self.create_class(unique_key, *attributes)
      raise raise_database_error('class', '$data_classes') unless $data_classes

      # Default values for when a class is created and no attributes are given.
      defaults = {
        name: "Class",
        exp_curve: [30, 20, 30, 30],
        parameter_curves: create_param_curves(
          "400+lvl*50",
          "80+lvl*10",
          "15+lvl*5/4",
          "15+lvl*5/4",
          "15+lvl*5/4",
          "15+lvl*5/4",
          "30+lvl*5/2",
          "30+lvl*5/2"
        ),
        note: ""
      }

      # Index of attributes in '*attributes' if multiple arguments are used.
      argument_indexes = {
        name: 0,
        exp_curve: 1,
        parameter_curves: 2,
        note: 3
      }

      raise ArgumentError, "ERROR: Wrong amount of arguments for 'create_class'. Got #{attributes.length + 1}, expected #{argument_indexes.length + 1} or less." if attributes.length > argument_indexes.length

      if attributes.first.is_a?(Hash)
        class_data = attributes.first
    
        BaseItemAttributes.handle_attributes_hash(class_data, defaults, unique_key, "class", {description: false, icon: false})
        ClassAttributes.handle_attributes_hash(class_data, defaults)
      else
        BaseItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key, "class", {description: false, icon: false})
        ClassAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
      end

      # Reserve an ID or find the reserved ID that exists for this class
      DatabaseId.handle_id(unique_key, CLASS_KEYS_LIST, $data_classes)
      
      # Create the class with the given attributes
      $data_classes[@id] = RPG::Class.new
      actor_class = $data_classes[@id]
      actor_class.id = @id
      actor_class.name = @name
      actor_class.exp_params = @exp_curve
      actor_class.params = @param_curves
      actor_class.note = @note

      AstiLib::MethodHooks.trigger_hook(:on_class_created, actor_class)
      return actor_class
    end

    INITIALIZE_CLASSES = lambda do
      # Loop through the stored name procs and initialize the class names
      @class_name_procs.each do |unique_key, name_proc|
        actor_class = find_class_by_key(unique_key)
        if actor_class
          actor_class.name = name_proc.call
        else
          puts "Class with key #{unique_key} not found."
        end
      end
    end
  end
end

AstiLib::MethodHooks.add_listener(:player_loaded, AstiLib::Database::INITIALIZE_CLASSES)

class RPG::Class
  include AstiLib::Database::Features::RateFeatures
  include AstiLib::Database::Features::ParameterFeatures
  include AstiLib::Database::Features::AttackFeatures
  include AstiLib::Database::Features::SkillFeatures
  include AstiLib::Database::Features::EquipFeatures
  include AstiLib::Database::Features::OtherFeatures
  include AstiLib::Database::Features::FeatureUtils

  include AstiLib::Database::Learnings
end