class Player
    attr_reader :name, :token 
    @@players = 0
    attr_accessor :turn
    def initialize()
        @name = ""
        @token = ""
        @turn = true
        while(@name == "")
            system "clear"
            puts "Player #{@@players + 1}: Enter Your Name:"
            @name = gets.chomp
        end
        while(@token == "")
            system "clear"
            puts "Thanks, #{@name}, now enter a single character to represent your pieces:"
            @token = gets.chomp[0]
        end
        @@players += 1
    end

end

class Match
    attr_reader :p1, :p2, :status
    attr_accessor :winner, :ongoing

    # array to hold values, only indicies 0,1,2,4,5,6,8,9,10 hold important data
    $status = [0,0,0,"-",0,0,0,"-",0,0,0]
    
    public
    def initialize
        system "clear"
        puts "NEW GAME!"
        @p1 = Player.new
        @p2 = Player.new
        @ongoing = true
        puts "#{p1.name} vs. #{p2.name}"
        puts "START!"
    end

    def next_round
        display_board()
        if p1.turn == true
            $status = take_turn(p1.name,1,$status)
            p1.turn = false
        else
            $status = take_turn(p1.name,-1,$status)
            p1.turn = true
        end
        check_winner($status)

    end
    
    private
    def display_board
        system "clear"
        rows = []
        puts "#{@p1.name} vs. #{@p2.name}"
        i = 1
        while i < 12 do
            diff = (i.to_i / 4)
            if i == 2 || i == 6 || i == 10
                rows[i-1] = "  #{$status[i-2]>0? @p1.token : $status[i-2]<0 ? @p2.token : i-1-diff}  |  #{$status[i-1]>0? @p1.token : $status[i-1]<0 ? @p2.token : i-diff}  |  #{$status[i]>0? @p1.token : $status[i]<0 ? @p2.token : i+1-diff}"
            elsif i%4 == 0
                rows[i-1] = "—————————————————"
            else
                rows[i-1] = "     |     |     "
            end
            puts rows[i-1]
            i += 1
        end
    end

    def take_turn (player_name, token_value, game_status)
        puts "#{player_name}: Choose a square (1-9)"
        player_choice = gets.chomp.to_i
        warning = validate_player_choice(player_choice, game_status)
        while warning.is_a?(Integer) != true
            display_board()
            puts warning
            puts "#{player_name}: Choose a square (1-9)"
            player_choice = gets.chomp.to_i
            warning = validate_player_choice(player_choice, game_status)
        end
        game_status[warning] = token_value
        return game_status
    end

    def validate_player_choice (choice,status)
        msg = false
        choice -= 1
        choice = choice + (choice/3)
        if choice < 0 || choice > 10
            msg = "You entered a value outside of the accepted range"
        else
            if status[choice] != 0
                msg = "You can't choose an occupied spot!"
            else
                msg = choice
            end
        end
        return msg
    end

    def check_winner(status)
        #win_conditions array represents sums of status array's sums in the 012, 345, 678, 036, 147, 258, 048, and 2,4,6 directions
        display_board()

        win_conditions = []
        win_conditions[0] = status[0] + status[1] + status[2]
        win_conditions[1] = status[4] + status[5] + status[6]
        win_conditions[2] = status[8] + status[9] + status[10]
        
        win_conditions[3] = status[0] + status[4] + status[8]
        win_conditions[4] = status[1] + status[5] + status[9]
        win_conditions[5] = status[2] + status[6] + status[10]
        
        win_conditions[6] = status[0] + status[5] + status[10]
        win_conditions[7] = status[2] + status[5] + status[8]

        win_conditions.each do |x|
            if x.abs > 2 
                @ongoing = false
                x > 0 ? @winner = @p1.name : @winner = @p2.name
            end
        end
    end
end

$match = Match.new
while($match.ongoing) do
    $match.next_round()
end
10.times do 
    puts "#{$match.winner} Wins!"
end

