class IdeaGenerator
  def initialize(categories)
    @first = RandomPage.new(categories)
    @second = RandomPage.new(categories)
  end

  def idea
    "#{@first.title} #{@second.title}"
  end

  def categories
    "#{@first.category} | #{@second.category}"
  end
end