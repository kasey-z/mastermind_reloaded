require 'sinatra'
require 'sinatra/reloader'




get '/' do
  $game = Game.new
  $pick = []
  $i = 0
  $win = false
  erb :index, :locals => {:data => [] , :message => $game.secret_balls }
end

post '/index' do
  $i += 1
  guess_code = [params[:first], params[:second], params[:third], params[:fourth]]
  guess_answer = $game.answer(guess_code)
  unless $win == true || $i >= 13
    message = $game.game_message(guess_answer)
    $pick << ([$i] + guess_code + [guess_answer])
    erb :index, :locals => {:data => $pick , :message => message }
  else
    redirect to('/')
  end
end



$colors=["R","B","Y","P","G","T"]

class Game
  attr_reader :secret_balls

   def initialize
     @secret_balls = $colors.sample(1) + $colors.sample(1) + $colors.sample(1) + $colors.sample(1)
   end

   def answer(guess_code)
     plus_minor = ''
     plus_minor = '' + "+"*calc_plus_qty(guess_code) + "-"*calc_minus_qty(guess_code)
   end

   def calc_plus_qty(guess_code)
     plus_qty = 0
     @secret_balls.each_with_index{ |ball, index| plus_qty += 1 if ball == guess_code[index] }
     plus_qty
   end

   def calc_minus_qty(guess_code)
     minus_qty = 0
     compare1 = guess_code.clone
     compare2 = @secret_balls.clone
     compare1.each do |a|
       index = compare2.find_index(a)
       compare2.delete_at(index) if index != nil
     end
     minus_qty = 4 - compare2.length - calc_plus_qty(guess_code)
   end

   def win?(answer)
     answer == "++++"
   end

   def lose?(answer)
     answer != "++++" && $i >= 12
   end

   def game_message(answer)
     if win?(answer)
       $win = true
       return "You win! Press 'Guess!' to restart the game."
     end
     return "You lose! Press 'Guess!' to restart the game." if lose?(answer)
     "You have #{12 - $i} chances left." if $i <13
   end
end
