module AstiLib

  # # Player
  # --------
  # This module has methods controlling the player and party data.
  module Player

    # Change the quantity of an item in the player's inventory.
      #
      # @param [Integer] item_id The ID of the item to change.
      # @param [Integer, Symbol] amount The amount to change (can be a number or :add, :remove, :remove_all).
      # @return [Nil]
    def self.change_items(item_id, amount)
      amount = parse_item_amount(item_id, amount)
      $game_party.gain_item($data_items[item_id], amount)
    end
    
    # Change the quantity of a weapon in the player's inventory.
    #
    # @param [Integer] weapon_id The ID of the weapon to change.
    # @param [Integer, Symbol] amount The amount to change (can be a number or :add, :remove, :remove_all).
    # @return [Nil]
    def self.change_weapons(weapon_id, amount)
      amount = parse_weapon_amount(weapon_id, amount)
      $game_party.gain_item($data_weapons[weapon_id], amount)
    end
    
    # Change the quantity of an armor in the player's inventory.
    #
    # @param [Integer] armor_id The ID of the armor to change.
    # @param [Integer, Symbol] amount The amount to change (can be a number or :add, :remove, :remove_all).
    # @return [Nil]
    def self.change_armor(armor_id, amount)
      amount = parse_armor_amount(armor_id, amount)
      $game_party.gain_item($data_armors[armor_id], amount)
    end
    
    # Change the player's currency (gold).
    #
    # @param [Integer, Symbol] amount The amount of currency to change (can be a number or :add, :remove).
    # @return [Nil]
    def self.change_currency(amount)
      amount = parse_amount(amount)
      $game_party.gain_gold(amount)
    end
    
    class << self
      private
    
      # Parse the amount for an item change based on the input symbol or value.
      #
      # @param [Integer] item_id The ID of the item.
      # @param [Integer, Symbol] amount The change amount or symbol (:add, :remove, :remove_all).
      # @return [Integer] The parsed amount for the item change.
      def parse_item_amount(item_id, amount)
        case amount
        when :add
          1
        when :remove
          -1
        when :remove_all
          -$game_party.item_number($data_items[item_id])
        else
          amount.to_i
        end
      end
    
      # Parse the amount for a weapon change based on the input symbol or value.
      #
      # @param [Integer] weapon_id The ID of the weapon.
      # @param [Integer, Symbol] amount The change amount or symbol (:add, :remove, :remove_all).
      # @return [Integer] The parsed amount for the weapon change.
      def parse_weapon_amount(weapon_id, amount)
        case amount
        when :add
          1
        when :remove
          -1
        when :remove_all
          -$game_party.item_number($data_weapons[weapon_id])
        else
          amount.to_i
        end
      end
    
      # Parse the amount for an armor change based on the input symbol or value.
      #
      # @param [Integer] armor_id The ID of the armor.
      # @param [Integer, Symbol] amount The change amount or symbol (:add, :remove, :remove_all).
      # @return [Integer] The parsed amount for the armor change.
      def parse_armor_amount(armor_id, amount)
        case amount
        when :add
          1
        when :remove
          -1
        when :remove_all
          -$game_party.item_number($data_armors[armor_id])
        else
          amount.to_i
        end
      end
    
      # Parse the amount for currency change based on the input symbol or value.
      #
      # @param [Integer, Symbol] amount The change amount or symbol (:add, :remove).
      # @return [Integer] The parsed amount for the currency change.
      def parse_amount(amount)
        case amount
        when :add
          1
        when :remove
          -1
        else
          amount.to_i
        end
      end
    end
  end
end