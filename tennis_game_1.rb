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

  def ==(other_points)
    amount == other_points.amount
  end
end

class GameState < Struct.new(:point1, :point2)
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

class DrawResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    [player1.points.to_s, 'All'].join('-')
  end
end

class DeuceResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    'Deuce'
  end
end

class InProgressResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    [player1.points.to_s, player2.points.to_s].join('-')
  end
end

class AdvantageResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    ['Advantage', winner_name].join(' ')
  end
end

class WinResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    ['Win for', winner_name].join(' ')
  end
end

class GameResult < Struct.new(:player1, :player2, :game_state)
  def to_s
    result_klass_for
      .new(player1, player2, winner_name)
      .to_s
  end

  private

  def result_klass_for
    {
      draw: DrawResult,
      deuce: DeuceResult,
      in_progress: InProgressResult,
      advantage: AdvantageResult,
      win: WinResult,
    }.fetch(game_state.current)
  end

  def winner_name
    return if player1.points == player2.points

    [player1, player2].max.name
  end
end

class PlayerRepository
  def initialize
    @store = {}
  end

  def write(*players)
    players.each do |player|
      store[player.name] ||= player
    end
  end

  def find_by(name:)
    store.fetch(name)
  end

  private

  attr_reader :store
end

class TennisGame1
  def initialize(player1_name, player2_name)
    @player1 = Player.new(name: player1_name)
    @player2 = Player.new(name: player2_name)
    @player_repository =
      PlayerRepository.new.tap { |repo| repo.write(player1, player2) }
  end

  def won_point(player_name)
    scorer = player_repository.find_by(name: player_name)
    scorer.add_point
  end

  def score
    game_state = GameState.new(player1.points.to_i, player2.points.to_i)
    GameResult.new(player1, player2, game_state).to_s
  end

  private

  attr_reader :player1, :player2, :player_repository
end
