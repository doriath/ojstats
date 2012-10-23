require 'spec_helper'

describe RankingPosition do
  let(:user) { User.create!(email: 'test@example.com', password: 'secret', display_name: 'Display Name') }
  let(:start_date) { Date.parse('2012/10/21') }
  let(:end_date) { Date.parse('2012/10/27') }
  subject(:ranking_position) { RankingPosition.new(user, start_date, end_date) }

  its(:user_name) { should == user.display_name }
  its(:user_id) { should == user.id }

  describe '#score' do
    it 'counts problems accepted on start_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 21, 12, 00))
      ranking_position.score.should == 1
    end

    it 'counts problems accepted on end_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 27, 12, 00))
      ranking_position.score.should == 1
    end

    it 'counts problems accepted between start_date and end_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 24, 12, 00))
      ranking_position.score.should == 1
    end

    it 'does not count problems accepted before start_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 20, 12, 00))
      ranking_position.score.should == 0
    end

    it 'does not count problems accepted after end_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 28, 12, 00))
      ranking_position.score.should == 0
    end
  end

  describe '#judges' do
    it 'creates judge result for every online judge' do
      ranking_position.judges.should have(2).judge_results
      ranking_position.judges.first.should be_a JudgeResult
    end
  end
end
