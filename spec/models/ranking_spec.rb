require 'spec_helper'

describe Ranking do
  context 'with one user' do
    let(:user) { Fabricate(:user) }
    let(:ranking) { Ranking.new(Date.new(2010, 10, 21), Date.new(2010, 10, 28)) }
    subject(:ranking_position) { ranking.positions.first }
    before { user.accepted_problems.create!(accepted_at: acctepted_at, online_judge: 'spoj', score: 1.23) }

    context 'when problem is solved on start date' do
      let(:acctepted_at) { Date.new(2010, 10, 21) }

      its(:user_name) { should == user.display_name }
      its(:user_id) { should == user.id }
      its(:score) { should == 1.23 }
      its(:num_problems) { should == 1 }
      its(:judge_results) { should have(2).judge_results }

      it 'have spoj judge result with one problem solved' do
        spoj_judge_result = ranking_position.judge_results.select { |jr| jr.judge_name == 'spoj' }.first
        spoj_judge_result.score.should == 1.23
        spoj_judge_result.num_problems.should == 1
      end

      it 'have plspoj judge result with none problem solved' do
        spoj_judge_result = ranking_position.judge_results.select { |jr| jr.judge_name == 'plspoj' }.first
        spoj_judge_result.score.should == 0
        spoj_judge_result.num_problems.should == 0
      end
    end

    context 'when problem is solved before start date' do
      let(:acctepted_at) { Date.new(2010, 10, 20) }
      its(:num_problems) { should == 0 }
    end

    context 'when problem is solved on end date' do
      let(:acctepted_at) { Date.new(2010, 10, 28) }
      its(:num_problems) { should == 1 }
    end

    context 'when problem is solved after end date' do
      let(:acctepted_at) { Time.zone.local(2010, 10, 29, 0, 0, 1) }
      its(:num_problems) { should == 0 }
    end

    context 'when problem is solved betwee start date and end date' do
      let(:acctepted_at) { Date.new(2010, 10, 24) }
      its(:num_problems) { should == 1 }
    end
  end

  context 'with multiple users' do
    let(:user) { Fabricate(:user) }
    let(:ranking) { Ranking.new(Date.new(2010, 10, 21), Date.new(2012, 10, 28)) }

    it 'sorts ranking by score' do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)

      user1.accepted_problems.create!(accepted_at: Date.new(2010, 10, 22), online_judge: 'spoj', score: 1.23)
      user2.accepted_problems.create!(accepted_at: Date.new(2010, 10, 22), online_judge: 'spoj', score: 2.34)

      ranking.positions.first.score.should == 2.34
    end
  end
end
