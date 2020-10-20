require "byebug"
require_relative "board.rb"
require_relative "tile.rb"

class SudokuGame

    def initialize
        
        @board = Board.new
    end

    def play

        play_round until @board.solved?
        
        system("clear")
        @board.print_grid
        puts "Congratulations! You solved the puzzle!"
        puts
    end

    def play_round

        system("clear")
        @board.print_grid

        puts "Enter the coordinates you want to place a number on"
        puts "separated by a comma. (e.g. 2,3 meaning x=2, y=3)"
        print "> "

        pos = gets.chomp.split(",").map(&:to_i)
        
        until @board.valid_coordinate?(pos)
            puts "Please enter valid coordinates!"
            pos = gets.chomp.split(",").map(&:to_i)     
        end

        puts "Enter the number:"
        print "> "

        num = gets.chomp.to_i
        
        until @board.valid_num?(num)
            puts "Please enter a valid number!"
            num = gets.chomp.to_i     
        end
        
        @board.place_value(pos, num)

        @board.check_for_dupes
    end

    

end


if __FILE__ == $PROGRAM_NAME
    
    game = SudokuGame.new
    game.play
end