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
