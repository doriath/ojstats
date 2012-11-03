require 'spec_helper'

module OnlineJudges
  describe Plspoj do
    describe '#fetch_accepted_problems' do
      it 'fetches only accepted problems' do
        mock_request 'http://pl.spoj.pl/status/doriath/signedlist/', 'doriath.spoj.signedlist'
        accepts = Plspoj.new.fetch_accepted_problems('doriath')
        accepts.should have(14).accepts
      end

      it 'returns the time of first accept' do
        mock_request 'http://pl.spoj.pl/status/multi_accept/signedlist/', 'multi_accept.spoj.signedlist'
        accepts = Plspoj.new.fetch_accepted_problems('multi_accept')
        accepts.should have(1).accepts
        accepts.first.problem.should == "TRCTARCH"
        accepts.first.accepted_at.should == Time.zone.parse('2012-05-16 02:00:00')
      end
    end

    describe '#fetch_problem' do
      it 'fetches num of accepts' do
        mock_request 'http://pl.spoj.pl/ranks/PRIME_T/', 'plspoj_ranks_PRIME_T.html'
        problem = Plspoj.new.fetch_problem('PRIME_T')
        problem.name.should == 'PRIME_T'
        problem.num_accepts.should == 4510
      end

      it 'fetches best and worst possible points for problem' do
        mock_request 'http://pl.spoj.pl/ranks/EUCGAME/', 'plspoj_ranks_EUCGAME.html'
        mock_request 'http://pl.spoj.pl/ranks/EUCGAME/start=100000', 'plspoj_ranks_EUCGAME_last.html'
        problem = Plspoj.new.fetch_problem('EUCGAME')
        problem.name.should == 'EUCGAME'
        problem.num_accepts.should == 2768
        problem.best_points.should == 15
        problem.worst_points.should == 5
      end
    end
  end

  describe ProblemsPage do
    it do
      mock_request 'http://pl.spoj.pl/problems/latwe/', 'plspoj_latwe.html'
      page = ProblemsPage.new('http://pl.spoj.pl/problems/latwe/')
      problems = page.problems

      problems.should have(50).problems
      problems.first.name.should == 'PRIME_T'
      problems.first.num_accepts.should == 4510
      problems.first.best_points.should be_nil
      problems.first.worst_points.should be_nil

      page.has_next?.should be_true
      page.next_url.should == 'http://pl.spoj.pl/problems/latwe/sort=0,start=50'
    end

    it do
      mock_request 'http://pl.spoj.pl/problems/latwe/sort=0,start=100', 'plspoj_latwe_last.html'
      page = ProblemsPage.new('http://pl.spoj.pl/problems/latwe/sort=0,start=100')

      page.next_url.should be_nil
      page.has_next?.should be_false
    end
  end
end
