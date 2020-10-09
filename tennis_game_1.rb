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
