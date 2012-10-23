require 'spec_helper'

describe Ranking do
  describe '#positions' do
    it 'sorts the ranking positions by score' do
      User.should_receive(:all).and_return([stub(), stub()])
      RankingPosition.should_receive(:new).and_return(stub(score: 2), stub(score: 3))

      ranking = Ranking.new(Date.today, Date.today)
      ranking.positions[0].score.should == 3
      ranking.positions[1].score.should == 2
    end
  end
end
