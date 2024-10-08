module AstiLib
  module Database
    @weapon_name_procs = {}
    @weapon_description_procs = {}

    # ## Create Weapon
    # This method adds a weapon to the 'Weapons' array in the database without overwriting the `Weapons.rvdata2` file.
    # Thus removing a call to this method also removes the weapon created by it from the game.
    # 
    # By using "unique keys" this method assigns an ID to the weapon you create. The ID is stored at:
    # `Game/Mods/AstiLib/ExternalData/weapon_keys.dat`
    # This is to avoid getting the players inventory mixed up when the install or remove other mods.
    # Because items in the players inventory are saved by their ID.
    # 
    # **This method can only be called after** `$data_weapons` **has been initialized.** A good way to do this would be to put this in
    # a method that hooks into `load_database()` like this: `AstiLib::MethodHooks.add_listener(:on_load_database, your_method)`.
    # 
    # Attributes for your weapon can be added to this method in multiple ways:
    # ### With multiple arguments
    # ```
    # AstiLib::Database.create_weapon(
    #   "ModName - Greatsword",           # The key of the weapon. Must be a string but is allowed to contain most special characters.
    #   "Greatsword",                     # The name of the weapon.
    #   "A large and powerfull sword." +  # The description of the weapon. Split into 2 lines to avoid getting 1 too long one.
    #   "\n[Physical] +20 ATK, -5 AGI",   # The '\n' means new line. A weapon only has 2 lines for the description.
    #   1,                                # The weapon type ID. Also allows any symbols in 'WEAPON_TYPE_SYMBOLS' but since these differ in different games, only ':none' exist by default.
    #   [0, 0, 20, 0, 0, 0, -5, 0],       # The parameters of the weapon. In this case ATK get increased by 20 and AGI gets reduced by 5.
    #   398,                              # The icon ID. Based on the IconSet file.
    #   35,                               # The attack Animation ID.
    #   250,                              # The price of the Weapon.
    #   ""                                # The notes. This doesn't have any effect on the game by itself, but can be used as meta data that scripts can detect.
    # )
    # ```
    # 
    # ### With a hash
    # ```
    # AstiLib::Database.create_weapon(
    #   "ModName - Greatsword",
    #   {
    #     name: "Greatsword",
    #     description: "A large and powerfull sword." +
    #       "\n[Physical] +20 ATK, -5 AGI",
    #     weapon_type: 1,
    #     parameters: { # Parameters can be in an array or hash regardless of a hash or multiple arguments are used.
    #       mhp: 0,
    #       mmp: 0,
    #       atk: 20,
    #       def: 0,
    #       mat: 0,
    #       mdf: 0,
    #       agi: -5,
    #       luk: 0
    #     },
    #     icon: 398,
    #     animation: 35,
    #     price: 250,
    #     note: ""
    #   }
    # )
    # ```
    # 
    # The benefit of using a hash is that you can put these attributes in any order and remove the ones where you use the default value:
    # 
    # ```
    # AstiLib::Database.create_weapon(
    #   "ModName - Greatsword",
    #   {
    #     name: "Greatsword",
    #     description: "A large and powerfull sword." +
    #       "\n[Physical] +20 ATK, -5 AGI",
    #     parameters: {
    #       atk: 20,
    #       agi: -5
    #     },
    #     icon: 398,
    #     animation: 35,
    #     price: 250
    #   }
    # )
    # ```
    # 
    # When using multiple arguments they must be put in an order.
    # The parameters must also be in a specific order if they are in an array.
    # 
    # The order:
    # - name
    # - description
    # - weapon type ID
    # - parameters
    #   - max hp
    #   - max mp
    #   - attack
    #   - defense
    #   - magic attack
    #   - magic defense
    #   - agility
    #   - luck
    # - icon index
    # - animation ID
    # - price
    # - notes
    # 
    # @param [String] unique_key Identifier of the weapon. Used to reserve an ID.
    # @param [Hash, Multiple] *attributes Can be either a single hash or multiple arguments
    # @return [RPG::Weapon] The weapon created by this method.
    def self.create_weapon(unique_key, *attributes)
      raise raise_database_error('weapon', '$data_weapons') unless $data_weapons
    
      # Default values for when a weapon is created and no attributes are given.
      defaults = {
        name: "Weapon",
        description: "",
        weapon_type: 0,
        parameters: [0, 0, 0, 0, 0, 0, 0, 0],
        icon: 0,
        animation: 0,
        price: 0,
        note: ""
      }
    
      # Index of attributes in '*attributes' if multiple arguments are used.
      argument_indexes = {
        name: 0,
        description: 1,
        weapon_type: 2,
        parameters: 3,
        icon: 4,
        animation: 5,
        price: 6,
        note: 7
      }

      raise ArgumentError, "ERROR: Wrong amount of arguments for 'create_weapon'. Got #{attributes.length + 1}, expected #{argument_indexes.length + 1} or less." if attributes.length > argument_indexes.length
    
      # Set attributes depending on if a hash or multiple arguments are used.
      if attributes.first.is_a?(Hash)
        weapon_data = attributes.first
    
        BaseItemAttributes.handle_attributes_hash(weapon_data, defaults, unique_key, "weapon")
        EquipItemAttributes.handle_attributes_hash(weapon_data, defaults, {equip_type: false})
        WeaponAttributes.handle_attributes_hash(weapon_data, defaults)
      else
        BaseItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key, "weapon")
        EquipItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, {equip_type: false})
        WeaponAttributes.handle_attributes_args(attributes, argument_indexes, defaults)
      end
    
      # Reserve an ID or find the reserved ID that exists for this weapon
      DatabaseId.handle_id(unique_key, WEAPON_KEYS_LIST, $data_weapons)
    
      # Create the weapon with the given attributes
      $data_weapons[@id] = RPG::Weapon.new
      weapon = $data_weapons[@id]
      weapon.id = @id
      weapon.name = @name
      weapon.description = @description
      weapon.wtype_id = @weapon_type
      weapon.params = @parameters
      weapon.icon_index = @icon
      weapon.animation_id = @animation
      weapon.price = @price
      weapon.note = @note
    
      AstiLib::MethodHooks.trigger_hook(:on_weapon_created, weapon)
      return weapon
    end

    # Takes an .rvdata2 file containing weapons and adds those weapons to the game.
    # **If the weapons in this file have dependencies (like skills) that do not appear in the basegame they will most likely break**
    # 
    # @param [String] file_path The location of the file.
    # @param [Boolean] skip_empty Skip files that have no name and no description.
    # @param [Range, Symbol] range The range of weapon indices to loop through e.g. `20...35`, default is :all.
    # @return [Array<RPG::Weapon>] The list of weapons that got added.
    def self.append_weapons(file_path, skip_empty = true, range = :all)
      weapon_list = []
      weapons = load_data(file_path)
    
      # Set the range to cover the entire array if range is :all
      if range == :all
        range = 0...(weapons.size)
      end
    
      weapons[range].each do |weapon_data|
        # Skip weapon if it doesn't exist
        next unless weapon_data
    
        if weapon_data.name == "" && weapon_data.description == ""
          next if skip_empty
        end
    
        unique_key = generate_unique_key(weapon_data.name, weapon_data.description, weapon_data.note)
    
        # Handle the ID allocation
        DatabaseId.handle_id(unique_key, WEAPON_KEYS_LIST, $data_weapons)
    
        # Create the weapon with the given attributes
        $data_weapons[@id] = RPG::Weapon.new
        weapon = $data_weapons[@id]
        weapon.id = @id
        weapon.name = weapon_data.name
        weapon.description = weapon_data.description
        weapon.wtype_id = weapon_data.wtype_id
        weapon.params = weapon_data.params
        weapon.icon_index = weapon_data.icon_index
        weapon.animation_id = weapon_data.animation_id
        weapon.price = weapon_data.price
        weapon.note = weapon_data.note
        weapon.features = weapon_data.features
    
        weapon_list << weapon
      end
      return weapon_list
    end

    class << self
      private

      # Create a unique key based on the weapon's attributes
      # 
      # @return [String]
      def generate_unique_key(weapon_name, weapon_description, weapon_note)
        return "#{AstiLib::Base64.encode(weapon_description[0,8] + weapon_note[0,8])} | #{weapon_name}"
      end
    end

    INITIALIZE_WEAPONS = lambda do
      # Loop through the stored name procs and initialize the weapon names
      @weapon_name_procs.each do |unique_key, name_proc|
        weapon = find_weapon_by_key(unique_key)
        if weapon
          weapon.name = name_proc.call
        else
          puts "Weapon with key #{unique_key} not found."
        end
      end

      # Loop through the stored description procs and initialize the weapon descriptions
      @weapon_description_procs.each do |unique_key, desc_proc|
        weapon = find_weapon_by_key(unique_key)
        if weapon
          weapon.description = desc_proc.call
        else
          puts "Weapon with key #{unique_key} not found."
        end
      end
    end

  end
end

AstiLib::MethodHooks.add_listener(:player_loaded, AstiLib::Database::INITIALIZE_WEAPONS)

# Add features
class RPG::Weapon
  include AstiLib::Database::Features::RateFeatures
  include AstiLib::Database::Features::ParameterFeatures
  include AstiLib::Database::Features::AttackFeatures
  include AstiLib::Database::Features::SkillFeatures
  include AstiLib::Database::Features::EquipFeatures
  include AstiLib::Database::Features::OtherFeatures
  include AstiLib::Database::Features::FeatureUtils
end