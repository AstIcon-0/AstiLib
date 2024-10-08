# Contains names of all plugins that want to notify other plugins they exist.
$imported = {} if $imported.nil?  # Create the `$imported` hash if it doesn't exist.
$imported["AstiLib"] = "0.3.2"    # Add AstiLib and include the version.

# # AstiLib
# ---
# Contains sub-modules that hold methods for creating RPGMaker objects easier within code,
# without overwriting any of the files from the game.
# 
# Sub-Modules:
# - ImportManager
# - Database
# - MethodHooks
# - Graphics
# - TitleScreen
# - ModSettings
# - Audio
# - FileData
# - Base64
# - WindowUtils
# - MonitorUtils
module AstiLib
  # The directory that holds .dat files.
  ASTILIB_EXT_DIR = File.join(MOD_DIR, "ExternalData/")

  LANGUAGE_SETTINGS = true
  LANGUAGE_FILE = File.join(MOD_DIR, "lang.txt")
end