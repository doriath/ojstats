require 'spec_helper'
require './lib/online_judges/polish_spoj/user_page.rb'

describe OnlineJudges::PolishSpoj::StatusPage do
  subject { OnlineJudges::PolishSpoj::StatusPage.new(url, 'ALGWLACZ') }

  context do
    let(:url) { 'http://pl.spoj.com/status/ALGWLACZ,doriath/' }
    before { mock_request url, 'spoj/plspoj_status_ALGWLACZ_doriath.html' }
    it 'should get attempts' do
      subject.attempts.size.should == 3
    end
    it 'should get first accept' do
      subject.first_accept.should == OnlineJudges::Accept.new(Time.parse('2007-07-09 14:47:45'), 'ALGWLACZ')
    end
  end
end
