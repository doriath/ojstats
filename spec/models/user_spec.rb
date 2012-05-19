require 'spec_helper'

describe User do
  describe '#import_accepted_problems' do
    it "should fetch accepted problems" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user = User.create!(email: 'doriath88@gmail.com', password: 'secret', online_judges: {plspoj: 'doriath'})
      user.import_accepted_problems

      user.accepted_problems.should have(14).elements
    end

    it "should be idempotent" do
      mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'

      user = User.create!(email: 'doriath88@gmail.com', password: 'secret', online_judges: {plspoj: 'doriath'})
      user.import_accepted_problems
      user.import_accepted_problems

      user.accepted_problems.should have(14).elements
    end
  end
end
