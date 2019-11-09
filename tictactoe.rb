class Player
    attr_reader :name, :token 
    @@players = 0
    def initialize()
        @name = ""
        @token = ""
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
    attr_reader :p1, :p2, :ongoing, :status

    $status = [1,-1,1,0,0,1,0,0,-1,-1,0]
    
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
        puts "#{p1.name}: Choose a square (1-9)"
        player_choice = gets.chomp
        # determind player turn
        # ask for input
        # check for victory
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

end

match = Match.new
while(match.ongoing) do
    match.next_round
end

