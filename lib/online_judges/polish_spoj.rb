module OnlineJudges
  class PolishSpoj
    def name
      'plspoj'
    end

    # @param [String] user_name
    # @return [Array<Accept>]
    def fetch_accepts(user_name)
      url = "http://pl.spoj.com/status/#{user_name}/signedlist/"
      OnlineJudges::Spoj::SignedlistParser.new(url).accepts
    end

    # @param [String] problem_name
    # @return [Problem]
    def fetch_problem(problem_name)
      url = "http://pl.spoj.com/ranks/#{problem_name}/"
      OnlineJudges::Spoj::ProblemPage.new(url).problem
    end

    # It will fetch name and number of accepts of each problem available on
    # given online judge. It will not fetch the maximum and minimum score
    # available for given problem. To fetch such information, use
    # #fetch_problem method.
    #
    # @return [Array<Problem>]
    def fetch_all_problems
      urls = ['http://pl.spoj.com/problems/latwe/',
              'http://pl.spoj.com/problems/srednie/',
              'http://pl.spoj.com/problems/trudne/']

      urls.map do |url|
        OnlineJudges::Spoj::ProblemsPage.problems_starting_from(url)
      end.flatten
    end
  end
end
