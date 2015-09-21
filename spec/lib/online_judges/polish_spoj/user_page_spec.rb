require 'spec_helper'
require './lib/online_judges/polish_spoj/user_page.rb'

describe OnlineJudges::PolishSpoj::UserPage do
  subject { OnlineJudges::PolishSpoj::UserPage.new(url) }

  context do
    let(:url) { 'http://pl.spoj.pl/users/doriath/' }
    before { mock_request url, 'spoj/plspoj_doriath.html' }
    it 'should get accepts' do
      subject.accepts.size.should == 226
    end
  end
end
