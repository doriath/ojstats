module OnlineJudges
  class EnglishSpoj
    def name
      'spoj'
    end

    # @param [String] user_name
    # @return [Array<Accept>]
    def fetch_accepts(user_name)
      url = "http://www.spoj.com/status/#{user_name}/signedlist/"
      OnlineJudges::Spoj::SignedlistParser.new(url).accepts
    end

    # @param [String] problem_name
    # @return [Problem]
    def fetch_problem(problem_name)
      url = "http://www.spoj.com/ranks/#{problem_name}/"
      OnlineJudges::Spoj::ProblemPage.new(url).problem
    end

    # It will fetch name and number of accepts of each problem available on
    # given online judge. It will not fetch the maximum and minimum score
    # available for given problem. To fetch such information, use
    # #fetch_problem method.
    #
    # @return [Array<Problem>]
    def fetch_all_problems
      url = 'http://www.spoj.com/problems/classical/'
      OnlineJudges::Spoj::ProblemsPage.problems_starting_from(url)
    end
  end
end
