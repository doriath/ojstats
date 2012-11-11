require 'spec_helper'

module OnlineJudges::Spoj
  describe OnlineJudges::Spoj::ProblemsPage do
    let(:url) { 'http://pl.spoj.pl/problems/latwe/' }
    subject(:problems_page) { ProblemsPage.new(url) }

    context 'first page of polish spoj easy problems' do
      before { mock_request url, 'spoj/plspoj_problems_easy.html' }

      its(:problems) { should have(50).problems }
      its(:has_next?) { should be_true }
      its(:next_url) { should == 'http://pl.spoj.pl/problems/latwe/sort=0,start=50' }
      it 'returns correct first problem' do
        problem = problems_page.problems.first
        problem.should == OnlineJudges::Problem.new('PRIME_T', 4510)
      end
    end

    context 'last page of polish spoj easy problems' do
      before { mock_request url, 'spoj/plspoj_problems_easy_last_page.html' }

      its(:problems) { should have(11).problems }
      its(:has_next?) { should be_false }
      its(:next_url) { should be_nil }
      it 'returns correct first problem' do
        problem = problems_page.problems.first
        problem.should == OnlineJudges::Problem.new('TAXIMAN3', 199)
      end
    end

    it 'should fetch all problems starting from given url' do
      mock_request url, 'spoj/plspoj_problems_easy.html'
      mock_request url + "sort=0,start=50", 'spoj/plspoj_problems_easy_last_page.html'

      ProblemsPage.problems_starting_from(url).should have(61).problems
    end
  end
end
