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
