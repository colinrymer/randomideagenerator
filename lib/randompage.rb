class RandomPage
  def initialize(pool)
      @pool = pool
  end

  def doc
    @doc ||= Nokogiri::HTML(open(url))
  end

  def title
    @title ||= doc.css('#mw-pages ul li a').map{|a| "<a href='http://en.wikipedia.org#{a['href']}'>#{a['title'].gsub(/\(.+\)/, '').downcase}</a>" }.sample
  end

  def category
    @category ||= "<a href='#{url}'>#{doc.css('title').children.first.content.split(' - Wikipedia, the free encyclopedia').first.split('Category:').last.sub('%E2%80%93', '-')}</a>"
  end

  def url
    @url ||= "http://en.wikipedia.org/wiki/Category:#{@pool.sample}"
  end
end