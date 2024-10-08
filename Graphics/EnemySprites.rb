module AstiLib

  # # Graphics
  # ----------
  # This module contains methods for modifying graphical parts of the game.
  module Graphics
    @@battler_replacements = {}

    # Replaces an enemy's sprite with a new one.
    #
    # @param [String, Symbol] original_battler_sprite The original sprite name or :all for replacing all.
    # @param [String] folder_path The folder path where the replacement sprite is located.
    # @param [String] new_battler_sprite The filename of the replacement sprite (without extension).
    # @param [Integer] hue The hue to apply to the battler, defaults to nil (use original hue).
    def self.replace_battler_sprite(original_battler_sprite, folder_path, new_battler_sprite, hue = nil)
      # Store replacement data including the folder, filename, hue, and scaling
      @@battler_replacements[original_battler_sprite] = {
        folder: folder_path, 
        filename: new_battler_sprite,
        hue: hue
      }
    end

    def self.get_battler_sprite_data(battler_sprite_name)
      @@battler_replacements[battler_sprite_name] || @@battler_replacements[:all]
    end
  end
end

module Cache
  class << self
    alias_method :astilib_battler, :battler

    def battler(filename, hue)
      # Check if there's a custom battler and load it with custom folder, hue, and scaling
      battler_data = AstiLib::Graphics.get_battler_sprite_data(filename)

      if battler_data
        custom_folder = battler_data[:folder]
        custom_filename = battler_data[:filename]
        custom_hue = battler_data[:hue] || hue
        
        bitmap = load_bitmap(custom_folder, custom_filename, custom_hue)
        return bitmap
      else
        astilib_battler(filename, hue)
      end
    end
  end
end