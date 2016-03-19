require 'spec_helper'
require './lib/online_judges/accept'
require './lib/online_judges/polish_spoj'

describe OnlineJudges::PolishSpoj do
  subject(:polish_spoj) { OnlineJudges::PolishSpoj.new }

  describe '#fetch_accepts' do
    it 'fetches accepts using user page', vcr: true do
      polish_spoj.fetch_accepts('doriath', []).size.should == 226
    end

    # Note: signedlist is no longer available
    # it 'fetches accepts using signedlist parser' do
    #   OnlineJudges::Spoj::SignedlistParser.
    #     should_receive(:new).
    #     with('http://pl.spoj.com/status/doriath/signedlist/').
    #     and_return(double(accepts: accepts))

    #   polish_spoj.fetch_accepts('doriath').should == accepts
    # end
  end

  describe '#fetch_problem' do
    let(:problem) { [OnlineJudges::Problem.new('PRIME', 1234)] }

    it 'fetches accepts using signedlist parser' do
      OnlineJudges::Spoj::ProblemPage.
        should_receive(:new).
        with('http://pl.spoj.com/ranks/PRIME/').
        and_return(double(problem: problem))

      polish_spoj.fetch_problem('PRIME').should == problem
    end
  end

  describe '#fetch_all_problems' do
    let(:problem_easy) { OnlineJudges::Problem.new('EASY', 1234) }
    let(:problem_medium) { OnlineJudges::Problem.new('MEDIUM', 1234) }
    let(:problem_hard) { OnlineJudges::Problem.new('HARD', 1234) }

    it 'fetches accepts using signedlist parser' do
      OnlineJudges::Spoj::ProblemsPage.
        should_receive(:problems_starting_from).
        with('http://pl.spoj.com/problems/latwe/').
        and_return([problem_easy])
      OnlineJudges::Spoj::ProblemsPage.
        should_receive(:problems_starting_from).
        with('http://pl.spoj.com/problems/srednie/').
        and_return([problem_medium])
      OnlineJudges::Spoj::ProblemsPage.
        should_receive(:problems_starting_from).
        with('http://pl.spoj.com/problems/trudne/').
        and_return([problem_hard])

      polish_spoj.fetch_all_problems.should =~
        [problem_easy, problem_medium, problem_hard]
    end
  end
end
