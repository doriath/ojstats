require 'spec_helper'

describe OnlineJudge do
  describe '#refresh' do
    let!(:user) { Fabricate(:user, online_judges: online_judges) }
    let(:online_judges) { [OnlineJudge.new(name: 'plspoj', login: 'doriath')] }
    let!(:problem) { Problem.create!(name: 'MWP3_2B1', online_judge: 'plspoj', score: 1) }

    it "should fetch accepted problems" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user.online_judges.first.refresh

      user.accepted_problems.should have(1).elements
    end

    it "should be idempotent" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user.online_judges.first.refresh
      user.online_judges.first.refresh

      user.accepted_problems.should have(1).elements
    end
  end
end
