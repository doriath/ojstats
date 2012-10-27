require 'spec_helper'

describe OnlineJudge do
  describe '#refresh' do
    let!(:user) { Fabricate(:user, online_judges: online_judges) }
    let(:online_judges) { [OnlineJudge.new(name: 'plspoj', login: 'doriath')] }

    it "should fetch accepted problems" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user.online_judges.first.refresh

      user.accepted_problems.should have(14).elements
    end

    it "should be idempotent" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user.online_judges.first.refresh
      user.online_judges.first.refresh

      user.accepted_problems.should have(14).elements
    end
  end
end
