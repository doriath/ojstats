require 'spec_helper'

describe RankingPosition do
  let(:user) { Fabricate(:user) }
  let(:judge_results) { [] }
  subject(:ranking_position) { RankingPosition.new(user, judge_results) }

  its(:user_name) { should == user.display_name }
  its(:user_id) { should == user.id }

  context 'with spoj and plspoj judge results' do
    let(:judge_results) { [JudgeResult.new('spoj', 1.23, 5), JudgeResult.new('plspoj', 2.34, 6)] }

    its(:judge_results) { should == judge_results }
    its(:score) { should == 1.23 + 2.34 }
    its(:num_problems) { should == 5 + 6 }
  end
end
