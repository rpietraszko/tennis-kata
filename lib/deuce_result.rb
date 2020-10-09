class DeuceResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    'Deuce'
  end
end
