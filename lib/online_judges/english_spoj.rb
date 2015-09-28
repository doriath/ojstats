module OnlineJudges
  class EnglishSpoj
    def name
      'spoj'
    end

    # @param [String] user_name
    # @return [Array<Accept>]
    def fetch_accepts(user_name, already_fetched_accepts)
      url = "http://www.spoj.com/status/#{user_name}/signedlist/"
      OnlineJudges::Spoj::SignedlistParser.new(url).accepts
    end

    # @param [String] user_name
    # @return [Array<Attempt>]
    def fetch_attempts(user_name)
      url = "http://www.spoj.com/status/#{user_name}/signedlist/"
      OnlineJudges::Spoj::SignedlistParser.new(url).attempts
    end

    # @param [String] problem_name
    # @return [Problem]
    def fetch_problem(problem_name)
      url = "http://www.spoj.com/ranks/#{problem_name}/"
      begin
        OnlineJudges::EnglishSpoj::ProblemPage.new(url).problem
      rescue => e
        raise e, "Problem #{url} failed", e.backtrace
      end
    end

    # It will fetch name and number of accepts of each problem available on
    # given online judge. It will not fetch the maximum and minimum score
    # available for given problem. To fetch such information, use
    # #fetch_problem method.
    #
    # @return [Array<Problem>]
    def fetch_all_problems
      url = 'http://www.spoj.com/problems/classical/'
      OnlineJudges::EnglishSpoj::ProblemsPage.problems_starting_from(url)
    end
  end
end
