require 'spec_helper'

describe Category do
  it 'fetches an array of all the categories' do
    Database.stubs(:all_categories).returns([1,2,3])
    Category.all.class.should == Array
  end

  it 'retrieves a random category' do
    Database.stubs(:random_category).returns(Random.rand(10))
    @rand = Category.random
    Database.stubs(:random_category).returns(Random.rand(10))
    10.times {@result = 'pass' if (@rand != Category.random)}
    @result.should == 'pass'
  end

  it 'adds new categories' do
    @category = 'test'
    Database.expects(:add_category).with(@category).returns(true)
    Category.add(@category).should == true
  end

  it 'removes unwanted categories' do
    @category = 'test'
    Database.expects(:remove_category).with(@category).returns(true)
    Category.remove(@category).should == true
  end
end