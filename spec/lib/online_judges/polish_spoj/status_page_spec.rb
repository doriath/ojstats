require 'spec_helper'
require './lib/online_judges/polish_spoj/user_page.rb'

describe OnlineJudges::PolishSpoj::StatusPage do
  context do
    subject { OnlineJudges::PolishSpoj::StatusPage.new(url, 'ALGWLACZ') }
    let(:url) { 'http://pl.spoj.com/status/ALGWLACZ,doriath/' }
    before { mock_request url, 'spoj/plspoj_status_ALGWLACZ_doriath.html' }
    it 'should get attempts' do
      subject.attempts.size.should == 3
    end
    it 'should get first accept' do
      subject.first_accept.should == OnlineJudges::Accept.new(Time.parse('2007-07-09 14:47:45'), 'ALGWLACZ')
    end
  end

  context do
    subject { OnlineJudges::PolishSpoj::StatusPage.new(url, 'TADDL') }
    let(:url) { 'http://pl.spoj.com/status/TADDL,doriath/' }
    before { mock_request url, 'spoj/plspoj_status_TADDL_doriath.html' }
    it 'should get attempts' do
      subject.attempts.size.should == 1
    end
    it 'should include number of points' do
      subject.first_accept.should == OnlineJudges::Accept.new(Time.parse('2007-05-04 13:44:29'), 'TADDL', 10)
    end
  end
end
