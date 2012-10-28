require 'spec_helper'

describe RankingPosition do
  let(:user) { Fabricate(:user) }
  let(:start_date) { Date.new(2012, 10, 21) }
  let(:end_date) { Date.new(2012, 10, 27) }
  subject(:ranking_position) { RankingPosition.new(user, start_date, end_date) }

  its(:user_name) { should == user.display_name }
  its(:user_id) { should == user.id }

  def create_accept_at date
    user.accepted_problems.create(
      accepted_at: date, online_judge: 'spoj', score: 1.23)
  end

  describe '#score' do
    it 'counts problems accepted on start_date' do
      create_accept_at Time.zone.local(2012, 10, 21, 12, 00)
      ranking_position.score.should == 1.23
    end

    it 'counts problems accepted on end_date' do
      create_accept_at Time.zone.local(2012, 10, 27, 12, 00)
      ranking_position.score.should == 1.23
    end

    it 'counts problems accepted between start_date and end_date' do
      create_accept_at Time.zone.local(2012, 10, 24, 12, 00)
      ranking_position.score.should == 1.23
    end

    it 'does not count problems accepted before start_date' do
      create_accept_at Time.zone.local(2012, 10, 20, 12, 00)
      ranking_position.score.should == 0
    end

    it 'does not count problems accepted after end_date' do
      create_accept_at Time.zone.local(2012, 10, 28, 12, 00)
      ranking_position.score.should == 0
    end
  end

  describe '#num_problems' do
    it 'counts problems from every online judge' do
      JudgeResult.should_receive(:new).
        and_return(stub(name: 'a', num_problems: 1),
                   stub(name: 'b', num_problems: 2))
      ranking_position.num_problems.should == 3
    end
  end

  describe '#judges' do
    it 'creates judge result for every online judge' do
      ranking_position.judges.should have(2).judge_results
      ranking_position.judges.first.should be_a JudgeResult
    end
  end
end
