module HumanGuess
class ComputerPlayer
   def initialize
     @human = HumanPlayer.new
     @game_board = GridsBoard.new
     @index = 12
     @secret_balls = $colors.sample(1) + $colors.sample(1) + $colors.sample(1) + $colors.sample(1)
   end

   def human_guess_game
     @game_board.display_board
     12.times do
       @human.guess
       @human.guess until @human.pick.all? {|a| $colors.include?(a)} && @human.pick.length == 4
       answer
       check_win?
       new_board
       @game_board.display_board
       break if game_over?
     end
     exclose
     @game_board.display_board
     puts check_win? ? "Congratulations! You win!" : "Game over!"
   end

   private

   def answer
     plus_qty = 0
     minus_qty = 0
     @secret_balls.each_with_index{ |ball, index| plus_qty += 1 if ball == @human.pick[index] }
     compare1 = @human.pick.clone
     compare2 = @secret_balls.clone
     compare1.each do |a|
       index = compare2.find_index(a)
       compare2.delete_at(index) if index != nil
     end
     minus_qty = 4 - compare2.length - plus_qty
     space_qty = 4 - ( plus_qty + minus_qty )
     @minus_plus = "+"*plus_qty + "-"*minus_qty + " "*space_qty
   end

    def exclose
      @game_board.board_account[0] = @secret_balls
      @game_board.board_account[0].push "    "
    end

    def new_board
      new_account = @human.pick.push @minus_plus
      @game_board.board_account[@index] = new_account
      @index -= 1
    end

    def check_win?
      @minus_plus == "++++" ? true : false
    end

    def game_over?
      (check_win? == true || @index < 1) ? true : false
    end
end

class HumanPlayer
   attr_accessor :pick

   def initialize
      @pick = []
   end

   def guess
     puts "Pick 4 color balls at a time, don't put anything between the balls."
     puts "For example: BYPG"
     @pick = gets.chomp.upcase.split('')
     until @pick.length == 4 && @pick.all? { |a| $colors.include? a }
       puts "Invalid input. Please choose four colors from R, B, Y, P, G and T:"
       @pick = gets.chomp.upcase.split('')
     end
   end
end

class GridsBoard
   attr_accessor :board_account

   $colors=["R","B","Y","P","G","T"]

   def initialize
     empty_arr = [" "," "," "," ","    "]
     enclosed_seceret = ["?","?","?","?","    "]
     @board_account = []
     12.times { @board_account.push empty_arr }
     @board_account.unshift enclosed_seceret
   end

    def display_board
      line = "\n-------------------------\n"
      y = ""
      @board_account.each do |arr|
        arr.each { |string| y += "| #{ string } |" }
        y += line
      end
      board = line + y + "    1    2    3    4   result:"
      system("cls")
      puts board.lines.map { |line| line.strip.center(50) }
      puts "Color choices: \nR:red; B:blue; Y:yellow; P:purple; G:green; T:tea"
      puts "result: \n(+):both color and position are correct\n(-):only color is correct"
    end
end

end
