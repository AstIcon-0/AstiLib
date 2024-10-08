module AstiLib
  module Database
    @actor_name_procs = {}
    @actor_description_procs = {}
    @actor_nickname_procs = {}

    def self.create_actor(unique_key, *attributes)
      raise raise_database_error('actor', '$data_actors') unless $data_actors
    
      # Default values for when an actor is created and no attributes are given.
      defaults = {
        name: "Actor",
        nickname: "",
        class: 0,
        initial_level: 1,
        max_level: 99,
        description: "",
        character_name: "",
        character_index: 0,
        face_name: "",
        face_index: 0,
        equips: [0, 0, 0, 0, 0],
        note: ""
      }
    
      # Index of attributes in '*attributes' if multiple arguments are used.
      argument_indexes = {
        name: 0,
        nickname: 1,
        class: 2,
        initial_level: 3,
        max_level: 4,
        description: 5,
        character_name: 6,
        character_index: 7,
        face_name: 8,
        face_index: 9,
        equips: 10,
        note: 11
      }

      raise ArgumentError, "ERROR: Wrong amount of arguments for 'create_actor'. Got #{attributes.length + 1}, expected #{argument_indexes.length + 1} or less." if attributes.length > argument_indexes.length
    
      # Set attributes depending on if a hash or multiple arguments are used.
      if attributes.first.is_a?(Hash)
        actor_data = attributes.first
    
        BaseItemAttributes.handle_attributes_hash(actor_data, defaults, unique_key, "actor", {icon: false})
        ActorAttributes.handle_attributes_hash(actor_data, defaults, unique_key)
      else
        BaseItemAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key, "actor", {icon: false})
        ActorAttributes.handle_attributes_args(attributes, argument_indexes, defaults, unique_key)
      end
    
      # Reserve an ID or find the reserved ID that exists for this actor
      DatabaseId.handle_id(unique_key, ACTOR_KEYS_LIST, $data_actors)
    
      # Create the actor with the given attributes
      $data_actors[@id] = RPG::Actor.new
      actor = $data_actors[@id]
      actor.id = @id
      actor.name = @name
      actor.nickname = @nickname
      actor.description = @description
      actor.class_id = @class
      actor.initial_level = @initial_level
      actor.max_level = @max_level
      actor.character_name = @character_name
      actor.character_index = @character_index
      actor.face_name = @face_name
      actor.face_index = @face_index
      actor.equips = @equips
      actor.note = @note
    
      AstiLib::MethodHooks.trigger_hook(:on_actor_created, actor)
      return actor
    end

    INITIALIZE_ACTORS = lambda do
      # Loop through the stored name procs and initialize the actor names
      @actor_name_procs.each do |unique_key, name_proc|
        actor = find_actor_by_key(unique_key)
        if actor
          actor.name = name_proc.call
        else
          puts "Actor with key #{unique_key} not found."
        end
      end

      # Loop through the stored description procs and initialize the actor descriptions
      @actor_description_procs.each do |unique_key, desc_proc|
        actor = find_actor_by_key(unique_key)
        if actor
          actor.description = desc_proc.call
        else
          puts "Actor with key #{unique_key} not found."
        end
      end

      @actor_nickname_procs.each do |unique_key, nickname_proc|
        actor = find_actor_by_key(unique_key)
        if actor
          actor.nickname = nickname_proc.call
        else
          puts "Actor with key #{unique_key} not found."
        end
      end
    end
  end
end

AstiLib::MethodHooks.add_listener(:player_loaded, AstiLib::Database::INITIALIZE_ACTORS)

# Add features
class RPG::Actor
  include AstiLib::Database::Features::RateFeatures
  include AstiLib::Database::Features::ParameterFeatures
  include AstiLib::Database::Features::AttackFeatures
  include AstiLib::Database::Features::SkillFeatures
  include AstiLib::Database::Features::EquipFeatures
  include AstiLib::Database::Features::OtherFeatures
  include AstiLib::Database::Features::FeatureUtils
end