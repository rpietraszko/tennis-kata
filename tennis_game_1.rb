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

  private

  attr_reader :current_point
end

class GameState < Struct.new(:point1, :point2)
  # STATES = [:draw, :deuce, :in_progress, :win]

  def point_diff
    (point1 - point2).abs
  end

  def point_max
    [point1, point2].max
  end

  def current
    return :draw if point_diff == 0 && point_max <= 2
    return :deuce if point_diff == 0 && point_max >= 3
    return :in_progress if point_diff.between?(1, 3) && point_max <= 3
    return :advantage if point_diff == 1 && point_max >= 3
    return :win if point_diff >= 2 && point_max >= 4
  end
end

class GameResult < Struct.new(:player1, :player2, :game_state)
  class DrawResult < Struct.new(:player1, :player2)
    def to_s
      [player1.points.to_s, 'All'].join('-')
    end
  end

  class DeuceResult < Struct.new(:player1, :player2)
    def to_s
      'Deuce'
    end
  end

  def to_s
    result = ''
    return DrawResult.new(player1, player2).to_s if game_state.current == :draw
    return DeuceResult.new(player1, player2).to_s if game_state.current == :deuce

    if game_state.current == :advantage or game_state.current == :win
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
    elsif game_state.current == :in_progress
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

  def p1points
    player1.points.to_i
  end

  def p2points
    player2.points.to_i
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
    game_state = GameState.new(player1.points.to_i, player2.points.to_i)
    GameResult.new(player1, player2, game_state).to_s
  end

  private

  attr_reader :player1, :player2
end
