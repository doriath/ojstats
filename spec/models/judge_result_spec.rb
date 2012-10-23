require 'spec_helper'

describe JudgeResult do
  let(:user) { User.create!(email: 'test@example.com', password: 'secret', display_name: 'Display Name') }
  let(:start_date) { Date.parse('2012/10/21') }
  let(:end_date) { Date.parse('2012/10/27') }
  subject(:judge_result) { JudgeResult.new('spoj', user, start_date, end_date) }

  its(:name) { should == 'spoj' }

  describe '#points' do
    it 'counts problems accepted on start_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 21, 12, 00), online_judge: 'spoj')
      judge_result.points.should == 1
    end

    it 'counts problems accepted on end_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 27, 12, 00), online_judge: 'spoj')
      judge_result.points.should == 1
    end

    it 'counts problems accepted between start_date and end_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 24, 12, 00), online_judge: 'spoj')
      judge_result.points.should == 1
    end

    it 'does not count problems accepted before start_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 20, 12, 00), online_judge: 'spoj')
      judge_result.points.should == 0
    end

    it 'does not count problems accepted after end_date' do
      user.accepted_problems.create(accepted_at: Time.zone.local(2012, 10, 28, 12, 00), online_judge: 'spoj')
      judge_result.points.should == 0
    end
  end
end
