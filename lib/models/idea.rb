%w(json nokogiri open-uri).each {|lib| require lib}

class Idea
  # class methods
  def self.all
    get '-inf', '+inf'
  end

  def self.good
    get '1', '+inf'
  end

  def self.bad
    get '-inf', '0'
  end

  # instance methods
  def initialize(new_idea = nil, new_categories = nil, new_score = nil)
    if new_idea && new_categories
      @idea, @categories, @score = new_idea, new_categories, new_score
    else
      @first, @second = RandomPage.new(Category.random), RandomPage.new(Category.random)
    end
  end

  def idea
    @idea ||= "#{@first.title} #{@second.title}"
  end

  def categories
    @categories ||= "#{@first.category} | #{@second.category}"
  end

  def score
    @score ||= 0
  end

  def upvote
    score
    @score += 1
    update_score 1
  end

  def downvote
    score
    @score += -1
    update_score -1
  end

  private
  def update_score(amount)
    Database.update_idea(idea, categories, amount)
  end

  def self.get(min, max)
    Database.fetch_ideas(min, max).map do |result|
      Idea.new(result[:idea], result[:categories], result[:score])
    end
  end
end