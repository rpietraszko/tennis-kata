class WinResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    ['Win for', winner_name].join(' ')
  end
end
