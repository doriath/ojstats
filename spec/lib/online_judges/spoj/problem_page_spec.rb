require 'spec_helper'

describe OnlineJudges::Spoj::ProblemPage do
  subject { OnlineJudges::Spoj::ProblemPage.new(url) }

  context do
    let(:url) { 'http://pl.spoj.pl/ranks/PRIME_T/' }
    before { mock_request url, 'spoj/PRIME_T.html' }
    its(:problem) { should == OnlineJudges::Problem.new('PRIME_T', 4510, 'http://pl.spoj.pl/problems/PRIME_T/') }
  end

  context do
    let(:url) { 'http://pl.spoj.pl/ranks/EUCGAME/' }
    before { mock_request url, 'spoj/EUCGAME.html' }
    before { mock_request url + "start=100000", 'spoj/EUCGAME_last_page.html' }
    its(:problem) { should == OnlineJudges::Problem.new('EUCGAME', 2768, 'http://pl.spoj.pl/problems/EUCGAME/', 15, 5) }
  end

  context 'for hidden problem without num_accepts' do
    let(:url) { 'http://pl.spoj.pl/ranks/JSORTBIZ/' }
    before { mock_request url, 'spoj/JSORTBIZ.html' }
    before { mock_request url + "start=100000", 'spoj/JSORTBIZ_last_page.html' }
    its(:problem) { should == OnlineJudges::Problem.new('JSORTBIZ', 830, 'http://pl.spoj.pl/problems/JSORTBIZ/') }
  end

  context 'for problem with float points' do
    let(:url) { 'http://pl.spoj.pl/ranks/PZPI06_X/' }
    before { mock_request url, 'spoj/PZPI06_X.html' }
    before { mock_request url + "start=100000", 'spoj/PZPI06_X_last_page.html' }
    its(:problem) { should == OnlineJudges::Problem.new('PZPI06_X', 191, 'http://pl.spoj.pl/problems/PZPI06_X/', 0.445999, 1) }
  end

  context 'for problem with points with text' do
    let(:url) { 'http://pl.spoj.pl/ranks/TCONNUM/' }
    before { mock_request url, 'spoj/TCONNUM.html' }
    before { mock_request url + "start=100000", 'spoj/TCONNUM_last_page.html' }
    its(:problem) { should == OnlineJudges::Problem.new('TCONNUM', 213, 'http://pl.spoj.pl/problems/TCONNUM/', 10, 3) }
  end

  context 'for problem with no accepts' do
    let(:url) { 'http://pl.spoj.pl/ranks/TPORT/' }
    before { mock_request url, 'spoj/TPORT.html' }
    its(:problem) { should == OnlineJudges::Problem.new('TPORT', 0, 'http://pl.spoj.pl/problems/TPORT/') }
  end
end
