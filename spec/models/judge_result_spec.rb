require 'spec_helper'

describe JudgeResult do
  let(:user) { Fabricate(:user) }
  let(:start_date) { Date.parse('2012/10/21') }
  let(:end_date) { Date.parse('2012/10/27') }
  subject(:judge_result) { JudgeResult.new('spoj', user, start_date, end_date) }

  its(:name) { should == 'spoj' }

  def create_accept_at date
    user.accepted_problems.create(
      accepted_at: date, online_judge: 'spoj', score: 1.23)
  end

  describe '#num_problems' do
    it 'counts problems accepted on start_date' do
      create_accept_at Time.zone.local(2012, 10, 21, 12, 00)
      judge_result.num_problems.should == 1
    end

    it 'counts problems accepted on end_date' do
      create_accept_at Time.zone.local(2012, 10, 27, 12, 00)
      judge_result.num_problems.should == 1
    end

    it 'counts problems accepted between start_date and end_date' do
      create_accept_at Time.zone.local(2012, 10, 24, 12, 00)
      judge_result.num_problems.should == 1
    end

    it 'does not count problems accepted before start_date' do
      create_accept_at Time.zone.local(2012, 10, 20, 12, 00)
      judge_result.num_problems.should == 0
    end

    it 'does not count problems accepted after end_date' do
      create_accept_at Time.zone.local(2012, 10, 28, 12, 00)
      judge_result.num_problems.should == 0
    end
  end

  describe '#score' do
    it 'counts problems accepted on start_date' do
      create_accept_at Time.zone.local(2012, 10, 21, 12, 00)
      judge_result.score.should == 1.23
    end

    it 'counts problems accepted on end_date' do
      create_accept_at Time.zone.local(2012, 10, 27, 12, 00)
      judge_result.score.should == 1.23
    end

    it 'counts problems accepted between start_date and end_date' do
      create_accept_at Time.zone.local(2012, 10, 24, 12, 00)
      judge_result.score.should == 1.23
    end

    it 'does not count problems accepted before start_date' do
      create_accept_at Time.zone.local(2012, 10, 20, 12, 00)
      judge_result.score.should == 0
    end

    it 'does not count problems accepted after end_date' do
      create_accept_at Time.zone.local(2012, 10, 28, 12, 00)
      judge_result.score.should == 0
    end
  end
end
