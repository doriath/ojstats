require 'spec_helper'

describe JudgeResult do
  subject(:judge_result) { JudgeResult.new('spoj', 2.34, 5) }

  its(:judge_name) { should == 'spoj' }
  its(:score) { should == 2.34 }
  its(:num_problems) { should == 5 }
end
