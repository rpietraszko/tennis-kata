class DrawResult < Struct.new(:player1, :player2, :winner_name)
  def to_s
    [player1.points.to_s, 'All'].join('-')
  end
end
