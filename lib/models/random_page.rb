%w( nokogiri open-uri ).each {|lib| require lib}

class RandomPage
  def initialize(category)
    @category = category
  end

  def doc
    @doc ||= Nokogiri::HTML(open(url))
  end

  def title
    @title ||= doc.css('#mw-pages ul li a').map{|a| "<a href='http://en.wikipedia.org#{a['href']}'>#{a['title'].gsub(/\(.+\)/, '').downcase}</a>" }.sample
  end

  def category
    "<a href='#{url}'>#{@category.gsub('_', ' ').gsub('%E2%80%93', '-')}</a>"
  end

  def url
    @url ||= "http://en.wikipedia.org/wiki/Category:#{@category}"
  end
end