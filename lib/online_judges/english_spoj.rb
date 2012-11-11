module OnlineJudges
  class EnglishSpoj
    # @param [String] user_name
    # @return [Array<Accept>]
    def fetch_accepts(user_name)
      url = "http://spoj.pl/status/#{user_name}/signedlist/"
      OnlineJudges::Spoj::SignedlistParser.new(url).accepts
    end

    # @param [String] problem_name
    # @return [Problem]
    def fetch_problem(problem_name)
      url = "http://spoj.pl/ranks/#{problem_name}/"
      OnlineJudges::Spoj::ProblemPage.new(url).problem
    end
  end
end
