require 'spec_helper'
require './lib/online_judges/accept'

describe OnlineJudges::EnglishSpoj do
  subject(:english_spoj) { EnglishSpoj.new }

  describe '#fetch_accepts' do
    let(:accepts) { [Accept.new('test', Time.zone.now)] }

    it 'fetches accepts using signedlist parser' do
      OnlineJudges::Spoj::SignedlistParser.
        should_receive(:new).
        with('http://spoj.pl/status/doriath/signedlist/').
        and_return(stub(accepts: accepts))

      english_spoj.fetch_accepts('doriath').should == accepts
    end
  end

  describe '#fetch_problem' do
    let(:problem) { [OnlineJudges::Problem.new('PRIME', 1234)] }

    it 'fetches accepts using signedlist parser' do
      OnlineJudges::Spoj::ProblemPage.
        should_receive(:new).
        with('http://spoj.pl/ranks/PRIME/').
        and_return(stub(problem: problem))

      english_spoj.fetch_problem('PRIME').should == problem
    end
  end
end