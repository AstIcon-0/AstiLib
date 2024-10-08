#==============================================================================
# This script add more functionality to the DataManager.
# It mostly add hooks so you can do stuff after the DataManger does something,
# while keeping your code separate from the DataManager. 
#==============================================================================

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
# This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================
module DataManager
  class << self
    alias_method :astilib_load_database_hook,             :load_database
    alias_method :astilib_load_normal_database_hook,      :load_normal_database
    alias_method :astilib_load_battle_test_database_hook, :load_battle_test_database
    alias_method :astilib_check_player_location_hook,     :check_player_location
    alias_method :astilib_create_game_objects_hook,       :create_game_objects
    alias_method :astilib_setup_new_game_hook,            :setup_new_game
    alias_method :astilib_setup_battle_test_hook,         :setup_battle_test
    alias_method :astilib_save_game_hook,                 :save_game
    alias_method :astilib_load_game_hook,                 :load_game
    alias_method :astilib_load_header_hook,               :load_header
    alias_method :astilib_delete_save_file_hook,          :delete_save_file
    alias_method :astilib_make_save_header_hook,          :make_save_header
    alias_method :astilib_make_save_contents_hook,        :make_save_contents
    alias_method :astilib_extract_save_contents_hook,     :extract_save_contents

    def load_database
      return_data = astilib_load_database_hook()
      AstiLib::MethodHooks.trigger_hook(:on_load_database)
      return return_data
    end

    def load_normal_database
      return_data = astilib_load_normal_database_hook()
      AstiLib::MethodHooks.trigger_hook(:on_load_normal_database)
      return return_data
    end

    def load_battle_test_database
      return_data = astilib_load_battle_test_database_hook()
      AstiLib::MethodHooks.trigger_hook(:on_load_battle_test_database)
      return return_data
    end

    def check_player_location
      return_data = astilib_check_player_location_hook()
      AstiLib::MethodHooks.trigger_hook(:on_check_player_location)
      return return_data
    end

    def create_game_objects
      return_data = astilib_create_game_objects_hook()
      AstiLib::MethodHooks.trigger_hook(:on_create_game_objects)
      return return_data
    end

    def setup_new_game
      return_data = astilib_setup_new_game_hook()
      AstiLib::MethodHooks.trigger_hook(:on_setup_new_game)
      return return_data
    end

    def setup_battle_test
      return_data = astilib_setup_battle_test_hook()
      AstiLib::MethodHooks.trigger_hook(:on_setup_battle_test)
      return return_data
    end

    def save_game(index)
      return_data = astilib_save_game_hook(index)
      AstiLib::MethodHooks.trigger_hook(:on_save_game, index)
      return return_data
    end

    def load_game(index)
      return_data = astilib_load_game_hook(index)
      AstiLib::MethodHooks.trigger_hook(:on_load_game, index)
      return return_data
    end

    def load_header(index)
      return_data = astilib_load_header_hook(index)
      AstiLib::MethodHooks.trigger_hook(:on_load_header, index)
      return return_data
    end


    def delete_save_file(index)
      return_data = astilib_delete_save_file_hook(index)
      AstiLib::MethodHooks.trigger_hook(:on_delete_save_file, index)
      return return_data
    end

    def make_save_header
      return_data = astilib_make_save_header_hook()
      AstiLib::MethodHooks.trigger_hook(:on_make_save_header)
      return return_data
    end

    def make_save_contents
      return_data = astilib_make_save_contents_hook()
      AstiLib::MethodHooks.trigger_hook(:on_make_save_contents)
      return return_data
    end

    def extract_save_contents(contents)
      return_data = astilib_extract_save_contents_hook(contents)
      AstiLib::MethodHooks.trigger_hook(:on_extract_save_contents, contents)
      return return_data
    end
  end
end

module AstiLib
  module Database

    class << self
      private

      # raise an error
      # Adds information about what database variable hasn't been loaded yet.
      # And what database item failed to create because of that.
      # 
      # @param [String] db_item
      # @param [String] data_variable
      # @return [Nil]
      def raise_database_error(db_item, data_variable)
        error_message = "Failed to create #{db_item}.\n" +
        "Error: `#{data_variable}` not loaded.\n" +
        "Wait on the database to load before creating #{db_item}s."

        raise error_message
      end
    end
  end
end