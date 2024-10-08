class Scene_Map < Scene_Base
  alias_method :astilib_update_hook, :update

  def update
    return_data = astilib_update_hook
    AstiLib::MethodHooks.trigger_hook(:on_current_map_update)
    return return_data
  end
end


class Game_Map
  alias_method :astilib_setup_map, :setup
  
  def setup(map_id)
    astilib_setup_map(map_id)
    load_events(map_id)
  end

  def load_events(map_id)
    AstiLib::Map.load_events(map_id)

    AstiLib::Map.get_events(map_id).each do |event_data|
      add_custom_event(event_data[:event], event_data[:x], event_data[:y])
    end
  end

  # Add custom event with RPG::Event and Game_Event
  def add_custom_event(event, x, y)
    event_id = @events.keys.max + 1
    event_data = RPG::Event.new(x, y)
    event_data.name = event.name  # Set event name

    # Assign pages and event commands to the event
    event.pages.each do |page|
      page.list ||= []
      
      # Ensure each page's list ends with the termination command (115)
      page.list.push(RPG::EventCommand.new(115, 0, 0)) unless page.list.any? { |cmd| cmd.code == 115 }

      event_data.pages << page
    end

    # Add RPG::Event to map data
    @map.events[event_id] = event_data
    @events[event_id] = Game_Event.new(@map_id, event_data)
  end
end


module AstiLib
  module Map
    @events = {}

    # Remove the events placed on a map
    event_files = Dir.glob(File.join(ASTILIB_EXT_DIR, 'map_???_events.dat'))

    event_files.each do |file|
      AstiLib::FileData.clear_file(file)
    end

    # Add event to a map
    def self.add_event(event, map_id, x = 0, y = 0)
      @events[map_id] ||= []
      
      # Store event's position
      event_data = { event: event, x: x, y: y }
      @events[map_id] << event_data
      
      # Save the updated event list to a file
      filename = File.join(ASTILIB_EXT_DIR, sprintf("map_%03d_events.dat", map_id))
      AstiLib::FileData.save_var_to_file("events", @events[map_id], filename, true)
    end

    # Load and retrieve events for a specific map
    def self.load_events(map_id)
      filename = File.join(ASTILIB_EXT_DIR, sprintf("map_%03d_events.dat", map_id))
      if File.exist?(filename)
        @events[map_id] = AstiLib::FileData.load_var_from_file("events", filename, true) || []
      end
    end

    # Get events for a specific map
    def self.get_events(map_id)
      @events[map_id] || []
    end
  end
end