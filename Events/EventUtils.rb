class Game_Event < Game_Character
  attr_reader :event
end

module AstiLib
  module Event

    # Allows you to print data about an event
    # **Events created through AstiLib are NOT loaded untill you are on the same map**
    def self.print_event_data(event_id, map_id = nil)
      if !map_id.nil?
        map = load_data("Data/Map%03d.rvdata2" % [map_id])
      elsif $game_map
        map = $game_map.map
      else
        puts "Map could not be found"
        return "Map could not be found"
      end

      event = map.events[event_id]

      unless event
        puts "Event #{event_id} could not be found"
        return "Event #{event_id} could not be found"
      end

      data_str = ""
      data_str << "\n-- Event #{event_id} --"
      data_str << "\nName: #{event.name}"
      data_str << "\nX coordinate: #{event.x}"
      data_str << "\nY coordinate: #{event.y}"
      data_str << "\nPages: #{event.pages.size}"

      event.pages.each_with_index do |page, index|
        data_str << "\n\n-- Page #{index + 1} --\n"

        data_str << "\n  -- Graphic --"
        data_str << "\n  Character Name: #{page.graphic.character_name}"
        data_str << "\n  Character Index: #{page.graphic.character_index}"
        data_str << "\n  Direction: #{page.graphic.direction}"
        data_str << "\n  Pattern: #{page.graphic.pattern}"
        data_str << "\n  Tile ID: #{page.graphic.tile_id}\n"

        data_str << "\n  -- Conditions --"
        data_str << "\n  Switch 1 Valid: #{page.condition.switch1_valid}"
        data_str << "\n  Switch 1 ID: #{page.condition.switch1_id}\n"

        data_str << "\n  Switch 2 Valid: #{page.condition.switch2_valid}"
        data_str << "\n  Switch 2 ID: #{page.condition.switch2_id}\n"

        data_str << "\n  Variable Valid: #{page.condition.variable_valid}"
        data_str << "\n  Variable ID: #{page.condition.variable_id}"
        data_str << "\n  Variable Value: #{page.condition.variable_value}\n"

        data_str << "\n  Self Switch Valid: #{page.condition.self_switch_valid}"
        data_str << "\n  Self Switch Ch: #{page.condition.self_switch_ch}\n"

        data_str << "\n  Item Valid: #{page.condition.item_valid}"
        data_str << "\n  Item ID: #{page.condition.item_id}\n"

        data_str << "\n  Actor Valid: #{page.condition.actor_valid}"
        data_str << "\n  Actor ID: #{page.condition.actor_id}\n"

        data_str << "\n  -- Autonomous Movement --"
        data_str << "\n  Move Type: #{page.move_type}"
        data_str << "\n  Move Speed: #{page.move_speed}"
        data_str << "\n  Move Frequency: #{page.move_frequency}"
        data_str << "\n  Move Route: #{page.move_route}   # More detailed move routes coming soon\n"

        data_str << "\n  -- Options --"
        data_str << "\n  Walk Anim: #{page.walk_anime}"
        data_str << "\n  Step Anim: #{page.step_anime}"
        data_str << "\n  Direction Fix: #{page.direction_fix}"
        data_str << "\n  Through: #{page.through}\n"

        data_str << "\n  -- Priority Type --\n  #{page.priority_type} (#{priority_type_name(page.priority_type)})"
        data_str << "\n  -- Trigger --\n  #{page.trigger} (#{trigger_name(page.trigger)})"
      end

      puts data_str
      return data_str
    end

    class << self
      private

      def priority_type_name(priority_id)
        terms = ["Below Characters", "Same as Characters", "Above Characters"]
        return terms[priority_id]
      end

      def trigger_name(trigger_id)
        terms = ["Action Button", "Player Touch", "Event Touch", "Autorun", "Parallel Process"]
        return terms[trigger_id]
      end
    end
  end
end