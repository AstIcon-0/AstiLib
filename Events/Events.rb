module AstiLib
  class AstiLib_Event
    attr_accessor :name, :pages

    def initialize(name)
      @name = name
      @pages = []  # Each page will store its graphic and event commands
    end

    # Set the graphic for a specific page
    def set_graphic(page, character_name, index, tile_id = 0)
      @pages[page] ||= RPG::Event::Page.new  # Create page if it doesn't exist

      # Set graphic data for the page
      @pages[page].graphic.character_name = character_name
      @pages[page].graphic.character_index = index
      @pages[page].graphic.tile_id = tile_id
    end

    # Add an event command to a specific page
    def add_event_command(page, command, *args)
      @pages[page] ||= RPG::Event::Page.new

      case command
      when :show_text
        graphic_name, graphic_index, window_type, window_location, text_to_display = args
        
        # Add the 'Show Text' command (101)
        @pages[page].list.push(RPG::EventCommand.new(101, 0, [graphic_name, graphic_index, window_type, window_location]))
        
        # Add the text to display (401)
        @pages[page].list.push(RPG::EventCommand.new(401, 0, [text_to_display]))
      
      when :script
        script_to_run = args[0]
        
        # Add the 'Script' command (355)
        @pages[page].list.push(RPG::EventCommand.new(355, 0, [script_to_run]))

      when :start_battle
        designation_type, troop_id, can_escape, can_lose = args
        
        # Add the 'Start Battle' command (301)
        @pages[page].list.push(RPG::EventCommand.new(301, 0, [designation_type, troop_id, can_escape ? 1 : 0, can_lose ? 1 : 0]))
        
      else
        raise "Unsupported command: #{command}"
      end
    end
  end
end
