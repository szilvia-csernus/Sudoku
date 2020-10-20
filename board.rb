require "byebug"
require "set"
require "colorize"
require_relative "tile.rb"

class Board

    NUMBERS = Set.new("1".."9")

    attr_accessor :grid

    def self.from_file(file_name)
        array = Array.new(9) {Array.new(9)}
        temp_array = File.readlines(file_name).map(&:chomp)
        temp_array.each_with_index do |row, i|
            row.each_char.with_index do |ele, j|
                if ele == "0"
                    value = " "
                    given = false
                else 
                    value = ele
                    given = true
                end
                array[i][j] = Tile.new(value, given)
            end
        end
        array
    end

    def initialize
        
        @grid = Board.from_file("./puzzles/sudoku1.txt")

    end

    def [](pos)
        row, col = pos
        grid[row][col]
    end

    def []=(pos, value)
        row, col = pos
        grid[row][col] = value
    end

    

    def print_grid
       
        new_grid = Array.new(9) {Array.new(9)}
        @grid.each_with_index do |row, i|
            row.each_with_index {|tile, j| new_grid[i][j] = tile.colour}
        end
        
        new_grid.flatten!
        
        puts "   1   2   3   4   5   6   7   8   9  ".on_blue
        print " ".on_blue
        puts "+ - - - - - + - - - - - + - - - - - +"
        arr = ("1".."9").to_a
        
        3.times do
            2.times do
                print arr.shift.on_blue
                3.times {print "| #{new_grid.shift.value} #{"|".colorize(:light_blue)} #{new_grid.shift.value} #{"|".colorize(:light_blue)} #{new_grid.shift.value} "} 
                print "|"
                puts
                print " ".on_blue
                3.times {print "+ #{"- + - + - ".colorize(:light_blue)}"}
                print "+"
                puts
            end
            print arr.shift.on_blue
            3.times {print "| #{new_grid.shift.value} #{"|".colorize(:light_blue)} #{new_grid.shift.value} #{"|".colorize(:light_blue)} #{new_grid.shift.value} "}
            print "|"
            puts
            print " ".on_blue
            puts "+ - - - - - + - - - - - + - - - - - +"
        end
    end

    def valid_num?(num)

        return false if !(1..9).to_a.include?(num)
        true
    end

    def valid_coordinate?(pos)
        return false if pos.length != 2
        return false if (pos.all?  {|i| 1 <= i && i <= 9}) == false
        row, col = pos
        
        # adjust the displayed coordinates for the computer's coordinates
        row -= 1
        col -= 1
        pos = [row, col]
        return false if self[pos].given == true
        true
    end

    def place_value(pos, num)
     
        row, col = pos
        row -= 1
        col -= 1
        pos = [row, col]
        self[pos].value = num.to_s
    end

    def arr_solved?(arr)
        return true if arr.to_set == Board::NUMBERS
        false
    end

    def dupes?(arr)
        hash = Hash.new(0)
        arr.map { |ele| hash[ele.value] += 1}
        hash.reject! { |k, v| k == " "}
        return true if hash.values.any? { |count| count > 1}
        false
    end
    
    # Board#check_numbers checks if there was any wrong input from the player 
    # so that in can highlight it later with the render method.
    

    def check_row(row_index)
        arr = @grid[row_index]
        dupes?(arr)
    end

    def check_col(col_index)
     
        arr = @grid.map { |row| row[col_index]}
        dupes?(arr)
    end

    def check_block(block_nr)
        arr = calculate_block(block_nr)
        dupes?(arr)
    end

    def calculate_block(block_nr)
        row_indices = []
        row_indices << ((block_nr-1) / 3) * 3
        row_indices << ((block_nr-1) / 3) * 3 + 1
        row_indices << ((block_nr-1) / 3) * 3 + 2
        col_indices = []
        col_indices << ((block_nr-1) % 3) * 3
        col_indices << ((block_nr-1) % 3) * 3 + 1
        col_indices << ((block_nr-1) % 3) * 3 + 2
        
        arr = []
        (0..2).each do |i|
            (0..2).each do |j|
                arr << @grid[row_indices[i]][col_indices[j]]
            end
        end
        arr
    end

    def block_nr(row, col)
        x = row / 3
        y = col / 3
        block_nr = x * 3 + y + 1
    end

    # this method flips the tiles "alert" attributes if there is any dupes in the row, col or block.
    def check_for_dupes
        #first every "alert" attribute is set back to false
        @grid.each do |row|
            row.each { |tile| tile.alert = false}
        end

        (0..8).each do |i|       
            #...then after checking for dupes, it flips the "alert"s for true. 
            if check_row(i) == true
                    @grid[i].each { |tile| tile.alert = true}
                end
            if check_col(i) == true
                @grid.map { |row| row[i].alert = true}
            end
            (0..8).each do |j|
                block_number = block_nr(i, j)
                if check_block(block_number) == true
                    arr = calculate_block(block_number)
                    arr.each { |tile| tile.alert = true}
                end
            end
        end
    end

    def solved?
        (0..8).each do |i|
            row = @grid[i].map { |tile| tile.value}
           
            return false if arr_solved?(row) == false
            col = @grid.map { |row| row[i].value}
            return false if arr_solved?(col) == false
        end
        
        true
    end
       


end
