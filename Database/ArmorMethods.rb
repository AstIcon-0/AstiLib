module AstiLib
  module Database
    @armor_name_procs = {}
    @armor_description_procs = {}

    def self.create_armor(unique_key, *attributes)
      raise raise_database_error('armor', '$data_armors') unless $data_armors
    
      # Default values for when an armor is created and no attributes are given.
      defaults = {
        name: "Armor",
        description: "",
        armor_type: 0,
        equip_type: 1,
        parameters: [0, 0, 0, 0, 0, 0, 0, 0],
        icon: 0,
        price: 0,
        note: ""
      }
    
      # Index of attributes in '*attributes' if multiple arguments are used.
      argument_indexes = {
        name: 0,
        description: 1,
        armor_type: 2,
        equip_type: 3,
        parameters: 4,
        icon: 5,
        price: 6,
        note: 7
      }

      raise ArgumentError, "ERROR: Wrong amount of arguments for 'create_armor'. Got #{attributes.length + 1}, expected #{argument_indexes.length + 1} or less." if attributes.length > argument_indexes.length
    
      # Set attributes depending on if a hash or multiple arguments are used.
      if attributes.first.is_a?(Hash)
        armor_data = attributes.first
    
        BaseItemAttributes.handle_attributes_hash(armor_data, defaults, unique_key, "armor")
        EquipItemAttributes.handle_attributes_hash(armor_data, defaults)
        ArmorAttributes.handle_attributes_hash(armor_data, defaults)
      else
        BaseItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key, "armor")
        EquipItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
        ArmorAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
      end
    
      # Reserve an ID or find the reserved ID that exists for this armor
      DatabaseId.handle_id(unique_key, ARMOR_KEYS_LIST, $data_armors)
    
      # Create the armor with the given attributes
      $data_armors[@id] = RPG::Armor.new
      armor = $data_armors[@id]
      armor.id = @id
      armor.name = @name
      armor.description = @description
      armor.etype_id = @equip_type
      armor.atype_id = @armor_type
      armor.params = @parameters
      armor.icon_index = @icon
      armor.price = @price
      armor.note = @note
    
      AstiLib::MethodHooks.trigger_hook(:on_armor_created, armor)
      return armor
    end

    INITIALIZE_ARMORS = lambda do
      # Loop through the stored name procs and initialize the armor names
      @armor_name_procs.each do |unique_key, name_proc|
        armor = find_armor_by_key(unique_key)
        if armor
          armor.name = name_proc.call
        else
          puts "Armor with key #{unique_key} not found."
        end
      end

      # Loop through the stored description procs and initialize the armor descriptions
      @armor_description_procs.each do |unique_key, desc_proc|
        armor = find_armor_by_key(unique_key)
        if armor
          armor.description = desc_proc.call
        else
          puts "Armor with key #{unique_key} not found."
        end
      end
    end
  end
end

AstiLib::MethodHooks.add_listener(:player_loaded, AstiLib::Database::INITIALIZE_ARMORS)

# Add features
class RPG::Armor
  include AstiLib::Database::Features::RateFeatures
  include AstiLib::Database::Features::ParameterFeatures
  include AstiLib::Database::Features::AttackFeatures
  include AstiLib::Database::Features::SkillFeatures
  include AstiLib::Database::Features::EquipFeatures
  include AstiLib::Database::Features::OtherFeatures
  include AstiLib::Database::Features::FeatureUtils
end