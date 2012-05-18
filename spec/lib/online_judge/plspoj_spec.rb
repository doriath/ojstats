require 'spec_helper'

describe OnlineJudge::Plspoj do
  it 'should fetch user submissions' do
    mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'
    submissions = OnlineJudge::Plspoj.new.fetch_submissions('doriath')
    submissions.should have(858).submissions
  end

  it 'should fetch other user submissions' do
    mock_request 'http://pl.spoj.pl/status/kareth/signedlist/', 'kareth.spoj.signedlist'
    submissions = OnlineJudge::Plspoj.new.fetch_submissions('kareth')
    submissions.should have(421).submissions
  end

  it 'should fetch only accepted problems' do
    mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'
    problems = OnlineJudge::Plspoj.new.fetch_accepted_problems('doriath')
    problems.should have(214).problems
  end

  pending 'should handle not existing user'

  def mock_request(url, file_name)
    content = File.open(File.join(Rails.root, "spec/assets/#{file_name}")).read
    response = Typhoeus::Response.new(body: content)
    Typhoeus::Hydra.hydra.stub(:get, url).and_return(response)
  end
end
