require 'spec_helper'

describe OnlineJudges::Plspoj do
  it 'should fetch user submissions' do
    mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'
    submissions = OnlineJudges::Plspoj.new.fetch_submissions('doriath')
    submissions.should have(32).submissions
  end

  it 'should fetch other user submissions' do
    mock_request 'http://pl.spoj.pl/status/kareth/signedlist/', 'kareth.spoj.signedlist'
    submissions = OnlineJudges::Plspoj.new.fetch_submissions('kareth')
    submissions.should have(30).submissions
  end

  it 'should fetch only accepted problems' do
    mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'
    problems = OnlineJudges::Plspoj.new.fetch_accepted_problems('doriath')
    problems.should have(14).problems
  end

  it 'should fetch only first accept' do
    mock_request 'http://pl.spoj.pl/status/multi_accept/signedlist/', 'multi_accept.spoj.signedlist'
    problems = OnlineJudges::Plspoj.new.fetch_accepted_problems('multi_accept')
    problems.should have(1).problem
    problems.first[:problem].should == "TRCTARCH"
    problems.first[:accepted_at].should == Time.zone.parse('2012-05-16 02:00:00')
  end
end
