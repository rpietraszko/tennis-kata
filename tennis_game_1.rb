class Player
  include Comparable

  attr_reader :name, :points

  def initialize(name:, points: PlayerPoint.new)
    @name = name
    @points = points
  end

  def add_point
    points.add
  end

  def <=>(other_player)
    points.amount <=> other_player.points.amount
  end
end

class PlayerPoint
  attr_reader :amount

  POINTS = %w[Love Fifteen Thirty Forty].freeze

  def initialize
    @amount = 0
  end

  def add
    @amount += 1
  end

  def to_s
    POINTS[amount]
  end

  def to_i
    amount
  end
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

  class InProgressResult < Struct.new(:player1, :player2)
    def to_s
      [player1.points.to_s, player2.points.to_s].join('-')
    end
  end

  class AdvantageResult < Struct.new(:player1, :player2)
    def to_s
      ['Advantage', [player1, player2].max.name].join(' ')
    end
  end

  class WinResult < Struct.new(:player1, :player2)
    def to_s
      ['Win for', [player1, player2].max.name].join(' ')
    end
  end

  def to_s
    return DrawResult.new(player1, player2).to_s if game_state.current == :draw
    return DeuceResult.new(player1, player2).to_s if game_state.current == :deuce
    return InProgressResult.new(player1, player2).to_s if game_state.current == :in_progress
    return AdvantageResult.new(player1, player2).to_s if game_state.current == :advantage
    return WinResult.new(player1, player2).to_s if game_state.current == :win
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
