class Game

attr_accessor :name, :release_date, :url, :developer, :genre, :summary

@@all = []

def initialize(name, release_date, url)
    @name = name
    @release_date = release_date
    @url = url
  end

  def self.all
      @@all
  end

  def save
    @@all << self
  end

  def self.create(name, release_date, url)
    game = self.new(name, release_date, url)
    @@all << game
    game
  end

  def self.today
    self.scrape_metacritic
  end

  def self.scrape_metacritic
    doc = Nokogiri::HTML(open("http://www.metacritic.com/browse/games/release-date/coming-soon/switch/date",
    ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'safari'))
    doc.css('div.product_wrap').each do |game|
      name = game.css('div.product_title').text.gsub(/\s+/, " ")
      release_date = game.css('li.stat.release_date').text.gsub(/\s+/, " ")
      url = game.css('div.product_title a')[0]["href"]
      new_game = Game.create(name, release_date, url)
    end
Game.all
end

def self.scrape_game(game)
  url = "http://www.metacritic.com" + game.url
  profile = Nokogiri::HTML(open(url,
  ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'safari'))
  profile.css('div.layout').each do |the_game|
    game.name = the_game.css('div.product_title').text.gsub(/\s+/, " ")
    game.release_date = the_game.css('li.summary_detail.release_data').text.gsub(/\s+/, " ")
    game.developer = the_game.css('li.summary_detail.developer').text.gsub(/\s+/, " ")
    game.genre = the_game.css('li.summary_detail.product_genre').text.gsub(/\s+/, " ")
    game.summary = the_game.css('li.summary_detail.product_summary').text.gsub(/\s+/, " ")
    game.save
end
game
end

end
