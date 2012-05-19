require 'spec_helper'

describe Problem do
  describe '#find_or_fetch_by' do
    let(:problem) { Problem.find_or_fetch_by(name: 'PRIME', online_judge: 'plspoj') }

    it 'should create new problem for the first time' do
      problem.should be_persisted
      problem.name.should == 'PRIME'
      problem.online_judge.should == 'plspoj'
      problem.score.should == 1
    end

    it 'should return already existing problem' do
      old_problem = Problem.create!(name: 'PRIME', online_judge: 'plspoj', score: 1)
      problem.should == old_problem
    end
  end
end
