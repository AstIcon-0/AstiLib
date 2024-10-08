module AstiLib
  module Event
    PRIORITY_TYPE_SYMBOLS = {
      below_characters: 0,
      same_as_characters: 1,
      above_characters: 2
    }

    TRIGGER_SYMBOLS = {
      action_button: 0,
      player_touch: 1,
      event_touch: 2,
      autorun: 3,
      parallel_process: 4
    }    
  end
end