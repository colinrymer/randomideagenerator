%w( nokogiri open-uri sinatra ).each {|lib| require lib}

class Doc

  # @approved = %w()

  def initialize
    # until (@approved & doc.categories).length > 0
      doc
    # end
  end

  def doc
    @doc ||= random_page
  end

  def new_doc
    @doc = random_page
  end

  def random_page
    @sites = %w( http://en.wikipedia.org/wiki/Category:National_Toy_Hall_of_Fame_inductees http://en.wikipedia.org/wiki/Category:Technology http://en.wikipedia.org/wiki/Category:Packaging http://en.wikipedia.org/wiki/Category:Animals_described_in_1758 http://en.wikipedia.org/wiki/Category:Simple_machines http://en.wikipedia.org/wiki/Category:Weapons http://en.wikipedia.org/wiki/Category:American_cuisine http://en.wikipedia.org/wiki/Category:Traditional_Chinese_objects http://en.wikipedia.org/wiki/Category:String_instruments http://en.wikipedia.org/wiki/Category:Creativity http://en.wikipedia.org/wiki/Category:American_inventions )
    # Nokogiri::HTML(open("http://en.wikipedia.org/wiki/Special:Random/"))
    Nokogiri::HTML(open(@sites.sample))
  end

  def random_title
    doc.css('#mw-pages ul li a').map{|a| a["title"]}.sample
  end

  def title
    # @doc.css('title').children.first.content.split(' - Wikipedia, the free encyclopedia').first
    @title ||= random_title
  end

  def category
    @category ||= @doc.css('title').children.first.content.split(' - Wikipedia, the free encyclopedia').first.split('Category:').last
  end

  def categories
    @doc.css("#catlinks div ul li a").map{ |a| a.attributes["title"].value.split("Category:").last.downcase }
  end
end

# Routes
get '/' do
  @first = Doc.new
  @second = Doc.new

  erb :index
end