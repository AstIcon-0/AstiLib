module AstiLib
  
  #==============================================================================
  # Methods for adding setting
  #==============================================================================
  module ModSettings
    @settings = []
    @settings_by_key = {}

    SETTINGS_FILE = AstiLib::ASTILIB_EXT_DIR + "settings.dat".freeze

    Setting = Struct.new(:key, :name, :type, :current_value, :category, :min_value, :max_value, :increment, :options)

    # Add a new boolean setting to the configuration
    def self.add_bool_setting(key, name, default_value, category = "General Settings")
      add_setting(key, name, :bool, default_value, category)
    end

    # Add a new integer setting to the configuration
    def self.add_int_setting(key, name, default_value, category = "General Settings", min_value = 0, max_value = 10, increment = 1)
      add_setting(key, name, :int, default_value, category, min_value, max_value, increment)
    end

    # Add a new float setting to the configuration
    def self.add_float_setting(key, name, default_value, category = "General Settings", min_value = 0.0, max_value = 10.0, increment = 0.1)
      add_setting(key, name, :flt, default_value, category, min_value, max_value, increment)
    end

    # Add a new string setting to the configuration
    def self.add_string_setting(key, name, default_value, category = "General Settings")
      add_setting(key, name, :str, default_value, category)
    end

    # Add a new enum setting to the configuration
    def self.add_enum_setting(key, name, default_value, options, category = "General Settings")
      add_setting(key, name, :enum, default_value, category, nil, nil, nil, options)
    end

    # Add a new setting to the configuration
    def self.add_setting(key, name, type, default_value, category = "General Settings", min_value = 0, max_value = 10, increment = 1, options = nil)
      setting = Setting.new(key, name, type, default_value, category, min_value, max_value, increment, options)
      @settings << setting
      @settings_by_key[key] = setting

      # Load saved value if it exists
      saved_value = load_setting(key)
      setting.current_value = saved_value unless saved_value.nil?
    end

    # Retrieve all settings
    def self.settings
      @settings
    end

    # Set the value for a given setting
    def self.set_setting(key, value)
      setting = @settings_by_key[key]
      if setting
        setting.current_value = value
        save_settings
      end
    end

    # Get the current value of a setting
    def self.get_setting(key)
      setting = @settings_by_key[key]
      setting ? setting.current_value : nil
    end

    # Group settings by their category
    def self.settings_by_category
      @settings.group_by(&:category)
    end

    # Save all settings to a file
    def self.save_settings
      settings_data = @settings.each_with_object({}) do |setting, hash|
        hash[setting.key] = setting.current_value
      end
      AstiLib::FileData.save_var_to_file('settings', settings_data, SETTINGS_FILE)
    end

    # Load all settings from a file
    def self.load_all_settings
      settings_data = AstiLib::FileData.load_var_from_file('settings', SETTINGS_FILE)
      settings_data.each do |key, value|
        @settings_by_key[key].current_value = value if @settings_by_key[key]
      end if settings_data
    end

    # Load a single setting from a file
    def self.load_setting(key)
      settings_data = AstiLib::FileData.load_var_from_file('settings', SETTINGS_FILE)
      settings_data ? settings_data[key] : nil
    end

    def self.has_settings?
      @settings.size > 0
    end

    # Load settings from file on startup
    load_all_settings
  end
end

#==============================================================================
# Scene that holds the settings menu
#==============================================================================
class Scene_Settings < Scene_MenuBase
  def start
    super
    create_settings_window
  end

  def create_settings_window
    @settings_window = Window_Settings.new(0, 0, Graphics.width, Graphics.height)
    @settings_window.set_handler(:cancel, method(:return_to_title))
  end

  def return_to_title
    SceneManager.goto(Scene_Title)
  end
end

#==============================================================================
# The settings menu
#==============================================================================
class Window_Settings < Window_Selectable
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @settings = AstiLib::ModSettings.settings_by_category
    @flat_settings = flatten_settings_with_headers
    refresh
    select(1)
    activate
  end

  def refresh
    contents.clear
    create_contents
    draw_settings
  end

  def draw_settings
    y = 0
    @settings.each do |category, settings|
      draw_category(category, y)
      y += line_height
      settings.each_with_index do |setting, index|
        draw_item(setting, y)
        y += line_height
      end
    end
  end

  def draw_category(category, y)
    rect = Rect.new(0, y, contents_width, line_height)
    category_text = category.is_a?(Proc) ? category.call : category
    draw_text(rect, category_text, 1)
  end

  def draw_item(setting, y)
    rect = item_rect_for_text(y / line_height)
    rect.y = y
    
    # Evaluate the name if it's a Proc, otherwise just use the value
    name_text = if setting.is_a?(AstiLib::ModSettings::Setting)
                  setting.name.is_a?(Proc) ? setting.name.call : setting.name
                else
                  setting
                end
  
    draw_text(rect.x, rect.y, rect.width / 2, rect.height, name_text)
  
    # Only draw value if it's a Setting object
    draw_value(setting, rect) if setting.is_a?(AstiLib::ModSettings::Setting)
  end

  # Draw the value of a setting based on its type
  def draw_value(setting, rect)
    value_text = case setting.type
                when :int, :integer then setting.current_value.to_s
                when :flt, :float then setting.current_value.to_f
                when :bool, :boolean then setting.current_value ? "ON" : "OFF"
                when :str, :string then setting.current_value
                when :enum then setting.options[setting.current_value] || "UNKNOWN"
                end
    draw_text(rect.x + rect.width / 2, rect.y, rect.width / 2, rect.height, value_text, 2)
  end

  def update
    super
    handle_input
  end

  def handle_input
    if Input.trigger?(:C)
      process_ok
    elsif Input.trigger?(:LEFT) || Input.trigger?(:RIGHT)
      change_setting_value
    elsif Input.trigger?(:DOWN)
      select_next
    elsif Input.trigger?(:UP)
      select_prev
    end
  end

  def process_ok
    setting = current_setting
    if [:bool, :boolean].include?(setting.type)
      change_setting_value
    elsif [:str, :string].include?(setting.type)
      RPG::SE.new('Cursor1', 80, 50).play
      msgbox_p("`String` type settings do not work yet.")
    end
  end

  # Change the value of the current setting based on input
  def change_setting_value
    setting = current_setting
    increment = setting.increment || 1

    case setting.type
    when :bool, :boolean
      setting.current_value = !setting.current_value
    when :str, :string
      return
    when :enum
      change_enum_value(setting)
    else
      adjust_value(setting, increment)
    end

    RPG::SE.new('Cursor1', 80, 50).play
    setting.current_value = clamp_value(setting)
    AstiLib::ModSettings.set_setting(setting.key, setting.current_value)
    AstiLib::MethodHooks.trigger_hook(:setting_changed, setting.key)
    refresh
  end

  # Change the value of an enum setting
  def change_enum_value(setting)
    if Input.trigger?(:LEFT)
      setting.current_value = (setting.current_value - 1) % setting.options.size
    elsif Input.trigger?(:RIGHT)
      setting.current_value = (setting.current_value + 1) % setting.options.size
    end
  end

  def adjust_value(setting, increment)
    if Input.trigger?(:LEFT)
      setting.current_value -= increment
    elsif Input.trigger?(:RIGHT)
      setting.current_value += increment
    end
  end

  def clamp_value(setting)
    value = setting.current_value
    value = [[value, setting.min_value].max, setting.max_value].min if setting.min_value && setting.max_value && (value.class == Fixnum || value.class == Float)
    value = value.round(4) if setting.type == :flt || setting.type == :float
    return value
  end

  def item_max
    @flat_settings ? @flat_settings.size : 0
  end

  def current_setting
    @flat_settings[index]
  end

  def select_next
    change_selection(1)
  end

  def select_prev
    change_selection(-1)
  end

  def change_selection(offset)
    new_index = index + offset * item_max
    new_index %= item_max

    while @flat_settings[new_index].is_a?(Hash)
      new_index += offset
      new_index %= item_max
    end

    select(new_index)
    play_cursor_sound
  end

  def play_cursor_sound
    RPG::SE.new('Cursor1', 80, 100).play
  end

  private

  def flatten_settings_with_headers
    @settings.flat_map { |category, settings| [{ category: category }] + settings }
  end

  def item_rect_for_text(index)
    rect = super(index)
    setting = @flat_settings[index]
    rect.y = line_height * index + (category_header_height(setting) * index)
    rect
  end

  def category_header_height(setting)
    setting.is_a?(Hash) ? 1 : 0
  end
end

#==============================================================================
# Add the mod settings button to the title menu
#==============================================================================
AstiLib::TitleScreen.add_command(
  Language.text('settingsButton', AstiLib::LANGUAGE_FILE),
  :open_settings_window,
  -> { AstiLib::ModSettings.has_settings? },
  :settings_window
)

#==============================================================================
# Give the mod setting button functionality
#==============================================================================
class Scene_Title < Scene_Base
  def settings_window
    SceneManager.call(Scene_Settings)
  end
end

#==============================================================================
# Add settings for the language
#==============================================================================
if AstiLib::LANGUAGE_SETTINGS
  AstiLib::ModSettings.add_enum_setting(
    "AstiLib.Language",
    Language.text('languageButton', AstiLib::LANGUAGE_FILE),
    0,
    Language.language_names,
    Language.text('languageHeader', AstiLib::LANGUAGE_FILE)
  )

  Language.set_language(Language.languages[AstiLib::ModSettings.load_setting("AstiLib.Language").to_i])
end