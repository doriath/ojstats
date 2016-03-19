require 'spec_helper'
require './lib/online_judges/accept'

describe OnlineJudges::EnglishSpoj do
  subject(:english_spoj) { EnglishSpoj.new }

  describe '#fetch_accepts' do
    let(:accepts) { [Accept.new('test', Time.zone.now)] }

    # it 'fetches accepts using signedlist parser' do
    #   OnlineJudges::Spoj::SignedlistParser.
    #     should_receive(:new).
    #     with('http://www.spoj.com/status/doriath/signedlist/').
    #     and_return(double(accepts: accepts))

    #   english_spoj.fetch_accepts('doriath', []).should == accepts
    # end
  end

  describe '#fetch_problem' do
    let(:problem) { [OnlineJudges::Problem.new('PRIME', 1234)] }

    # it 'fetches accepts using signedlist parser' do
    #   OnlineJudges::Spoj::ProblemPage.
    #     should_receive(:new).
    #     with('http://www.spoj.com/ranks/PRIME/').
    #     and_return(double(problem: problem))

    #   english_spoj.fetch_problem('PRIME').should == problem
    # end
  end

  describe '#fetch_all_problems' do
    let(:problem) { [OnlineJudges::Problem.new('PRIME', 1234)] }

    # it 'fetches accepts using signedlist parser' do
    #   OnlineJudges::Spoj::ProblemsPage.
    #     should_receive(:problems_starting_from).
    #     with('http://www.spoj.com/problems/classical/').
    #     and_return([problem])

    #   english_spoj.fetch_all_problems.should == [problem]
    # end
  end
end
