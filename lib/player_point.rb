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
