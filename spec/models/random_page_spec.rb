require 'spec_helper'

describe RandomPage do
  before do
    @category = 'Sex_positions'
    @formatted_category = @category.gsub('_', ' ').gsub('%E2%80%93', '-')
    @page = RandomPage.new(@category)
  end

  it 'fetches the Wikipedia category page' do
    @title = @page.doc.css('head title').first.children.first.content
    @title.should == "Category:#{@formatted_category} - Wikipedia, the free encyclopedia"
  end

  it 'only randomly selects one article title' do
    @page.title.should == @page.title
  end

  it 'returns the category as an anchor tag' do
    @page.category.should == "<a href='http://en.wikipedia.org/wiki/Category:#{@category}'>#{@formatted_category}</a>"
  end

  it 'generates the Wikipedia category URL' do
    @page.url.should == "http://en.wikipedia.org/wiki/Category:#{@category}"
  end
end