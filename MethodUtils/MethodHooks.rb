module AstiLib

  # # Method Hooks
  # --------------
  # This module contains methods for hooking code into
  # 'events' that can be called from anywhere.
  module MethodHooks
    # Contains methods and what they listen for.
    @@method_hooks = Hash.new { |hash, key| hash[key] = [] }
  
    # ## Add Listener
    # Allows for hooking methods for when specific code runs, without needing
    # the code to be part of the Class/Module that the trigger is in.
    # 
    # ### Creating a method for the listener:
    # ```
    # listening_method = lambda do |*args|
    #   # Your functionality here
    # end
    # 
    # AstiLib::MethodHooks.add_listener(:event, listening_method)
    # ```
    #
    # `*args` must be the same amount of arguments as when this hook is called.
    #
    # ### Example using `:on_player_moved`:
    # ```
    # print_player_moved = lambda do |x, y, last_x, last_y|
    #   puts "Player moved to: #{x}, #{y}"
    #   puts "Player moved from: #{last_x}, #{last_y}"
    # end
    # 
    # AstiLib::MethodHooks.add_listener(:on_player_moved, print_player_moved)
    # ```
    # 
    # @param [Any] event_name The name of the event you want methods to hook to.
    # @param [Method] listener The method you want to hook the an event.
    # @return [Nil]
    def self.add_listener(event_name, listener)
      @@method_hooks[event_name] << listener
    end
  
    # Allows for unhooking methods from specific code that is was connected to earlier.
    # 
    # @param [Any] event_name The name of the event you want methods to unhook from.
    # @param [Method] listener The method you want to unhook the an event.
    # @return [Nil]
    def self.remove_listener(event_name, listener)
      @@method_hooks[event_name].delete(listener)
    end
  
    # Calls all methods attached to the hook with the same event name.
    # **The arguments in the trigger must be the same for method that listens to this hook.**
    # 
    # ## Example
    # ```
    # # This example already exists in AstiLib
    # AstiLib::MethodHooks.trigger_hook(:on_player_moved, x, y, last_x, last_y)
    # ```
    # 
    # @param [any] event_name The name of the event you want other code to hook to. A symbol is recommended.
    # @param [*any] *args Any arguments that you whant the method to be able to use.
    # @return [Nil]
    def self.trigger_hook(event_name, *args)
      @@method_hooks[event_name].each { |listener| listener.call(*args) }
    end
  end
end