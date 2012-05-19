require 'spec_helper'

describe Ranking do
  let(:user) { User.create!(email: 'doriath88@gmail.com', password: 'secret', online_judges: {plspoj: 'doriath'}, display_name: 'Tomasz Zurkowski') }
  before do
    mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'
    user.import_accepted_problems
  end

  describe '#rebuild' do
    it do
      Ranking.global.rebuild

      Ranking.global.positions.should have(1).position
      position = Ranking.global.positions.first
      position.user.should == 'Tomasz Zurkowski'
      position.score.should == 14.0
    end

    it 'should be idempotent' do
      Ranking.global.rebuild
      Ranking.global.rebuild

      Ranking.global.positions.should have(1).position
      position = Ranking.global.positions.first
      position.user.should == 'Tomasz Zurkowski'
      position.score.should == 14.0
    end
  end
end
