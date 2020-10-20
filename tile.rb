require "colorize"

class Tile

    attr_reader :given
    attr_accessor :value, :alert

    def initialize(value, given)

        @value = value
        @given = given
        @alert = false
        
    end

    def colour
        new_tile = self.clone
        if new_tile.given == false
            new_tile.value = new_tile.value.to_s.colorize(:light_green)
        end

        if new_tile.alert == true
            new_tile.value = new_tile.value.to_s.on_light_black
        end
        new_tile
    end



end