module AstiLib
  module Database

    # Adds a new element including a symbol to be used
    def self.add_new_element(element_name, symbols)
      raise raise_database_error('new element', '$data_system') unless $data_system
    
      # Check if element_name already exists
      if $data_system.elements.include?(element_name)
        puts "Element '#{element_name}' already exists in $data_system.elements"
        return
      end
    
      filtered_symbols = []

      # Check if any symbol already exists in ELEMENT_SYMBOLS
      symbols.each do |symbol|
        if ELEMENT_SYMBOLS.key?(symbol)
          puts "Symbol :#{symbol} already exists in ELEMENT_SYMBOLS and will not be added"
        else
          filtered_symbols << symbol
        end
      end

      if filtered_symbols.empty?
        puts "All symbols already exist and the element will not be added"
        return
      end
    
      # Add the new element to the elements array
      $data_system.elements << element_name
      new_element_index = $data_system.elements.size - 1
    
      # Add new element to ELEMENT_SYMBOLS
      symbols.each do |symbol|
        ELEMENT_SYMBOLS[symbol] = new_element_index
      end
    
      return new_element_index
    end

    # Adds a new skill type including a symbol to be used
    def self.add_new_skill_type(skill_type_name, symbols)
      raise raise_database_error('new skill type', '$data_system') unless $data_system
    
      if $data_system.skill_types.include?(skill_type_name)
        puts "Skill type '#{skill_type_name}' already exists in $data_system.skill_types"
        return
      end
    
      filtered_symbols = []

      symbols.each do |symbol|
        if SKILL_TYPE_SYMBOLS.key?(symbol)
          puts "Symbol :#{symbol} already exists in SKILL_TYPE_SYMBOLS and will not be added"
        else
          filtered_symbols << symbol
        end
      end

      if filtered_symbols.empty?
        puts "All symbols already exist and the skill type will not be added"
        return
      end
    
      # Add the new skill_type to the skill_types array
      $data_system.skill_types << skill_type_name
      new_skill_type_index = $data_system.skill_types.size - 1
    
      symbols.each do |symbol|
        SKILL_TYPE_SYMBOLS[symbol] = new_skill_type_index
      end
    
      return new_skill_type_index
    end

    # Adds a new weapon type including a symbol to be used
    def self.add_new_weapon_type(weapon_type_name, symbols)
      raise raise_database_error('new weapon type', '$data_system') unless $data_system
    
      if $data_system.weapon_types.include?(weapon_type_name)
        puts "Skill type '#{weapon_type_name}' already exists in $data_system.weapon_types"
        return
      end
    
      filtered_symbols = []

      symbols.each do |symbol|
        if WEAPON_TYPE_SYMBOLS.key?(symbol)
          puts "Symbol :#{symbol} already exists in WEAPON_TYPE_SYMBOLS and will not be added"
        else
          filtered_symbols << symbol
        end
      end

      if filtered_symbols.empty?
        puts "All symbols already exist and the weapon type will not be added"
        return
      end
    
      # Add the new weapon type to the weapon types array
      $data_system.weapon_types << weapon_type_name
      new_weapon_type_index = $data_system.weapon_types.size - 1
    
      symbols.each do |symbol|
        WEAPON_TYPE_SYMBOLS[symbol] = new_weapon_type_index
      end
    
      return new_weapon_type_index
    end

    # Adds a new armor type including a symbol to be used
    def self.add_new_armor_type(armor_type_name, symbols)
      raise raise_database_error('new armor type', '$data_system') unless $data_system
    
      if $data_system.armor_types.include?(armor_type_name)
        puts "Skill type '#{armor_type_name}' already exists in $data_system.armor_types"
        return
      end
    
      filtered_symbols = []

      symbols.each do |symbol|
        if ARMOR_TYPE_SYMBOLS.key?(symbol)
          puts "Symbol :#{symbol} already exists in ARMOR_TYPE_SYMBOLS and will not be added"
        else
          filtered_symbols << symbol
        end
      end

      if filtered_symbols.empty?
        puts "All symbols already exist and the armor type will not be added"
        return
      end
    
      # Add the new armor type to the armor types array
      $data_system.armor_types << armor_type_name
      new_armor_type_index = $data_system.armor_types.size - 1
    
      symbols.each do |symbol|
        ARMOR_TYPE_SYMBOLS[symbol] = new_armor_type_index
      end
    
      return new_armor_type_index
    end
  end
end