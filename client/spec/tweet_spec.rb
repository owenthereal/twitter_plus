require 'spec_helper'

describe Tweet do
  before :all do
    @drb_factory = DRbObject.new(nil, 'druby://localhost:9000')
  end

  it "creates a tweet" do
    a_tweet = Tweet.create(:text => "a tweet")
    a_tweet.text.should == "a tweet"
  end

  it "gets a tweet" do
    remote_tweet_port = @drb_factory.get_port_for_fixture_instance(:tweet)
    remote_tweet = DRbObject.new(nil, "druby://localhost:#{remote_tweet_port}")

    found_tweet = Tweet.find(remote_tweet.id)
    found_tweet.text.should == "an awesome tweet"
  end

  it "gets all tweets" do
    # RemoteFactory.create(:tweet)
    Tweet.create(:text => "a tweet")
    Tweet.all.size.should == 1
  end
end
