require 'spec_helper'

describe OnlineJudges::Spoj::ProblemPage do
  subject { OnlineJudges::Spoj::ProblemPage.new(url) }

  context do
    let(:url) { 'http://pl.spoj.pl/ranks/PRIME_T/' }
    before { mock_request url, 'spoj/PRIME_T.html' }
    its(:problem) { should == OnlineJudges::Problem.new('PRIME_T', 4510) }
  end

  context do
    let(:url) { 'http://pl.spoj.pl/ranks/EUCGAME/' }
    before { mock_request url, 'spoj/EUCGAME.html' }
    before { mock_request url + "start=100000", 'spoj/EUCGAME_last_page.html' }
    its(:problem) { should == OnlineJudges::Problem.new('EUCGAME', 2768, 15, 5) }
  end

  context 'for hidden problem without num_accepts' do
    let(:url) { 'http://pl.spoj.pl/ranks/JSORTBIZ/' }
    before { mock_request url, 'spoj/JSORTBIZ.html' }
    before { mock_request url + "start=100000", 'spoj/JSORTBIZ_last_page.html' }
    its(:problem) { should == OnlineJudges::Problem.new('JSORTBIZ', 830) }
  end
end
