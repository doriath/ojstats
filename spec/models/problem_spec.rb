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

  describe '#create_from_scraper!' do
    it 'score for polish spoj' do
      problem_data = OnlineJudges::Problem.new('PRIME', 30)
      problem = Problem.create_from_scraper!(problem_data, 'plspoj')
      problem.score.should == 0.5
    end

    it 'score for english spoj' do
      problem_data = OnlineJudges::Problem.new('PRIME', 30)
      problem = Problem.create_from_scraper!(problem_data, 'spoj')
      problem.score.round(2).should == 1.14
    end

    it 'should set minimum score to 0.1' do
      problem_data = OnlineJudges::Problem.new('PRIME', 3000)
      problem = Problem.create_from_scraper!(problem_data, 'plspoj')
      problem.score.should == 0.1
    end
  end
end
