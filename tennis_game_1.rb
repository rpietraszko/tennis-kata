class Player
  attr_reader :name, :points

  def initialize(name:, points: PlayerPoint.new)
    @name = name
    @points = points
  end

  def add_point
    points.add
  end
end

class PlayerPoint
  POINTS = %w[Love Fifteen Thirty Forty].freeze

  def initialize
    @current_point = 0
  end

  def add
    @current_point += 1
  end

  def to_s
    POINTS[current_point]
  end

  def to_i
    @current_point
  end
end

class TennisGame1
  def initialize(player1_name, player2_name)
    @player1 = Player.new(name: player1_name)
    @player2 = Player.new(name: player2_name)
    @p1points, @p2points = @player1.points.to_i, @player2.points.to_i
  end

  def won_point(player_name)
    if player_name == @player1.name
      @player1.add_point
    else
      @player2.add_point
    end
  end

  def score
    result = ""
    tempScore=0
    if (p1points==p2points)
      result = {
          0 => "Love-All",
          1 => "Fifteen-All",
          2 => "Thirty-All",
      }.fetch(p1points, "Deuce")
    elsif (p1points>=4 or p2points>=4)
      minusResult = p1points-p2points
      if (minusResult==1)
        result ="Advantage " + player1.name
      elsif (minusResult ==-1)
        result ="Advantage " + player2.name
      elsif (minusResult>=2)
        result = "Win for " + player1.name
      else
        result ="Win for " + player2.name
      end
    else
      (1...3).each do |i|
        if (i==1)
          tempScore = p1points
        else
          result+="-"
          tempScore = p2points
        end
        result += {
            0 => "Love",
            1 => "Fifteen",
            2 => "Thirty",
            3 => "Forty",
        }[tempScore]
      end
    end
    result
  end

  private

  attr_reader :player1, :player2

  def p1points
    player1.points.to_i
  end

  def p2points
    player2.points.to_i
  end
end
