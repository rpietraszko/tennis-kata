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
