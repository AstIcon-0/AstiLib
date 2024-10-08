module AstiLib

  module TitleScreen
    #==============================================================================
    # Add more commands to title screen
    #==============================================================================
    @custom_commands = []

    def self.custom_commands
      @custom_commands
    end

    def self.add_command(name, symbol, enabled = true, method_name = nil)
      custom_commands << {name: name, symbol: symbol, enabled: enabled, method_name: method_name}
    end

    #==============================================================================
    # Change title images
    #==============================================================================
    @replacement_background = nil
    @replacement_border = nil
    @background_visibility = true
    @border_visibility = true

    def self.set_title_background(image_path)
      @replacement_background = image_path
    end

    def self.get_title_background
      @replacement_background
    end

    def self.set_title_border(image_path)
      @replacement_border = image_path
    end

    def self.get_title_border
      @replacement_border
    end

    #==============================================================================
    # Change title screen visibility
    #==============================================================================
    def self.hide_background
      @background_visibility = false
    end

    def self.hide_border
      @border_visibility = false
    end

    def self.show_background
      @background_visibility = true
    end

    def self.show_border
      @border_visibility = true
    end

    class << self
      attr_accessor :background_visibility, :border_visibility
    end
  end
end

class Window_TitleCommand < Window_Command
  alias_method :astilib_make_command_list, :make_command_list

  def make_command_list
    astilib_make_command_list
    add_custom_commands
  end

  def add_custom_commands
    # Remove the last command (shutdown)
    shutdown_command = @list.pop
    # Add custom commands
    AstiLib::TitleScreen.custom_commands.each do |command|
      name = command[:name].is_a?(Proc) ? command[:name].call : command[:name]
      enabled = command[:enabled].is_a?(Proc) ? command[:enabled].call : command[:enabled]
      add_command(name, command[:symbol], enabled)
    end
    # Re-add the shutdown command at the end
    @list << shutdown_command
  end
end

#==============================================================================
# Add functionality to commands
#==============================================================================
class Scene_Title < Scene_Base
  alias_method :astilib_create_command_window, :create_command_window

  def create_command_window
    astilib_create_command_window

    # Loop through the added custom commands and add their method
    AstiLib::TitleScreen.custom_commands.each do |command|
      @command_window.set_handler(command[:symbol], method(command[:method_name])) if command[:method_name]
    end
  end
end

#==============================================================================
# Load replacement title image
#==============================================================================
class Scene_Title < Scene_Base
  alias_method :astilib_create_background, :create_background

  def create_background
    AstiLib::MethodHooks.trigger_hook(:pre_title_background_graphics_load)
  
    # Background logic
    replacement_background = AstiLib::TitleScreen.get_title_background
    if replacement_background && File.exist?(replacement_background)
      create_custom_background(replacement_background)
    else
      puts "Replacement background file not found: #{replacement_background}" if replacement_background
      create_default_background
    end
  
    # Border logic
    replacement_border = AstiLib::TitleScreen.get_title_border
    if replacement_border && File.exist?(replacement_border)
      create_custom_border(replacement_border)
    else
      puts "Replacement border file not found: #{replacement_border}" if replacement_border
      create_default_border
    end
  end
  
  def create_custom_background(image_path)
    @sprite1 = Sprite.new
    background_bitmap = Bitmap.new(image_path)
    @sprite1.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprite1.bitmap.stretch_blt(Rect.new(0, 0, Graphics.width, Graphics.height), background_bitmap, background_bitmap.rect)
    center_sprite(@sprite1)
    
    @sprite1.visible = false unless AstiLib::TitleScreen.background_visibility
  end
  
  def create_custom_border(image_path)
    @sprite2 = Sprite.new
    border_bitmap = Bitmap.new(image_path)
    @sprite2.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprite2.bitmap.stretch_blt(Rect.new(0, 0, Graphics.width, Graphics.height), border_bitmap, border_bitmap.rect)
    center_sprite(@sprite2)
    
    @sprite2.visible = false unless AstiLib::TitleScreen.border_visibility
  end
  
  # Default background if custom one is not found
  def create_default_background
    @sprite1 = Sprite.new
    default_background_bitmap = Cache.title1($data_system.title1_name)
    @sprite1.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprite1.bitmap.stretch_blt(Rect.new(0, 0, Graphics.width, Graphics.height), default_background_bitmap, default_background_bitmap.rect)
    center_sprite(@sprite1)

    @sprite1.visible = false unless AstiLib::TitleScreen.background_visibility
  end
  
  # Default border if custom one is not found
  def create_default_border
    @sprite2 = Sprite.new
    default_border_bitmap = Cache.title2($data_system.title2_name)
    @sprite2.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @sprite2.bitmap.stretch_blt(Rect.new(0, 0, Graphics.width, Graphics.height), default_border_bitmap, default_border_bitmap.rect)
    center_sprite(@sprite2)

    @sprite2.visible = false unless AstiLib::TitleScreen.border_visibility
  end
  
  def center_sprite(sprite)
    sprite.x = (Graphics.width - sprite.bitmap.width) / 2
    sprite.y = (Graphics.height - sprite.bitmap.height) / 2
  end
end