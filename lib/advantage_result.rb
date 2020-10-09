class AdvantageResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    ['Advantage', winner_name].join(' ')
  end
end
