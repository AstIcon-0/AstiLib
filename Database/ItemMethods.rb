module AstiLib
  module Database
    @item_name_procs = {}
    @item_description_procs = {}

    def self.create_item(unique_key, *attributes)
      raise raise_database_error('item', '$data_items') unless $data_items
    
      # Default values for when an item is created and no attributes are given.
      defaults = {
        # General settings
        name: "Item",
        description: "",
        icon: 0,
        item_type: 1,
        price: 0,
        consumable: true,
        scope: 7,
        occasion: 0,
        # Invocation
        speed: 0,
        success_rate: 100,
        repeats: 1,
        tp_gain: 0,
        hit_type: 0,
        animation: 0,
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
        item_type: 3,
        price: 4,
        consumable: 5,
        scope: 6,
        occasion: 7,
        speed: 8,
        success_rate: 9,
        repeats: 10,
        tp_gain: 11,
        hit_type: 12,
        animation: 13,
        damage_type: 14,
        damage_element: 15,
        formula: 16,
        variance: 17,
        critical: 18,
        note: 19
      }

      raise ArgumentError, "ERROR: Wrong amount of arguments for 'create_item'. Got #{attributes.length + 1}, expected #{argument_indexes.length + 1} or less." if attributes.length > argument_indexes.length
    
      # Set attributes depending on if a hash or multiple arguments are used.
      if attributes.first.is_a?(Hash)
        item_data = attributes.first

        BaseItemAttributes.handle_attributes_hash(item_data, defaults, unique_key, "item")
        ItemAttributes.handle_attributes_hash(item_data, defaults)
        UsableItemAttributes.handle_attributes_hash(item_data, defaults)
        DamageAttributes.handle_attributes_hash(item_data, defaults)
      else
        BaseItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key, "item")
        ItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
        UsableItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
        DamageAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
      end
    
      # Reserve an ID or find the reserved ID that exists for this item
      DatabaseId.handle_id(unique_key, ITEM_KEYS_LIST, $data_items)
    
      # Create the item with the given attributes
      $data_items[@id] = RPG::Item.new
      item = $data_items[@id]
      item.id = @id
      item.name = @name
      item.description = @description
      item.icon_index = @icon
      item.itype_id = @item_type
      item.price = @price
      item.consumable = @consumable
      item.scope = @scope
      item.occasion = @occasion
      item.speed = @speed
      item.success_rate = @success_rate
      item.repeats = @repeats
      item.tp_gain = @tp_gain
      item.hit_type = @hit_type
      item.animation_id = @animation
      item.damage.type = @damage_type
      item.damage.element_id = @damage_element
      item.damage.formula = @formula
      item.damage.variance = @variance
      item.damage.critical = @critical
      item.note = @note
    
      AstiLib::MethodHooks.trigger_hook(:on_item_created, item)
      return item
    end

    INITIALIZE_ITEMS = lambda do
      # Loop through the stored name procs and initialize the item names
      @item_name_procs.each do |unique_key, name_proc|
        item = find_item_by_key(unique_key)
        if item
          item.name = name_proc.call
        else
          puts "item with key #{unique_key} not found."
        end
      end

      # Loop through the stored description procs and initialize the item descriptions
      @item_description_procs.each do |unique_key, desc_proc|
        item = find_item_by_key(unique_key)
        if item
          item.description = desc_proc.call
        else
          puts "item with key #{unique_key} not found."
        end
      end
    end
  end
end

AstiLib::MethodHooks.add_listener(:player_loaded, AstiLib::Database::INITIALIZE_ITEMS)

class RPG::Item
  include AstiLib::Database::Effects::RecoverEffects
  include AstiLib::Database::Effects::StateEffects
  include AstiLib::Database::Effects::ParameterEffects
  include AstiLib::Database::Effects::OtherEffects
  include AstiLib::Database::Effects::EffectUtils
end