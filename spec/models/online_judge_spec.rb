require 'spec_helper'

describe OnlineJudge do
  describe '#refresh' do
    it "should fetch accepted problems" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user = User.create!(display_name: 'test', email: 'doriath88@gmail.com', password: 'secret', online_judges: [OnlineJudge.new(name: 'plspoj', login: 'doriath')])
      user.online_judges.first.refresh

      user.accepted_problems.should have(14).elements
    end

    it "should be idempotent" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user = User.create!(display_name: 'test', email: 'doriath88@gmail.com', password: 'secret', online_judges: [OnlineJudge.new(name: 'plspoj', login: 'doriath')])
      user.online_judges.first.refresh
      user.online_judges.first.refresh

      user.accepted_problems.should have(14).elements
    end
  end
end
