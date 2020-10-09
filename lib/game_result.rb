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
