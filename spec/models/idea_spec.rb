require 'spec_helper'

describe Idea do

  it "has an idea" do
    RandomPage.any_instance.stubs(:title).returns('test')
    subject.idea.should_not == nil
  end

  it "has two categories" do
    RandomPage.any_instance.stubs(:category).returns('test')
    subject.categories.should == 'test | test'
  end

  it "has a score" do
    subject.score.class.should == Fixnum
  end

  context "returns an array" do
    it "has ideas with a good score" do
      Idea.stubs(:get).returns([Idea.new('test', 'test', 1)])
      @good = Idea.good
      @good.class.should == Array
      @good.first.score.should >= 0.0
    end

    it "has ideas with a bad score" do
      Idea.stubs(:get).returns([Idea.new('test', 'test', -1)])
      @bad = Idea.bad
      @bad.class.should == Array
      @bad.first.score.should <= 0.0
    end
  end

  context "can be voted on" do
    before do
      Database.stubs(:update_idea).returns(true)
      @score = 4
      @idea = Idea.new('test', {}, @score)
    end

    it "can be upvoted" do
      @idea.upvote
      @idea.score.should == (@score + 1)
    end

    it "can be downvoted" do
      @idea.downvote
      @idea.score.should == (@score - 1)
    end
  end
end