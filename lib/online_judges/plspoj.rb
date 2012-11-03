require 'typhoeus'

module OnlineJudges
  class Plspoj < SpojBase
    def url_base
      "http://pl.spoj.pl"
    end

    # @example
    #
    # [{problem_name: 'FIB', num_accepts: 234},
    #  {problem_name: 'FIB1', num_accepts: 500}]
    #
    # @return [Array]
    def fetch_all_problems
      problems = []
      ['http://pl.spoj.pl/problems/latwe/', 'http://pl.spoj.pl/problems/srednie/', 'http://pl.spoj.pl/problems/trudne/'].each do |url|
        problems << fetch_all_problems_starting_from(url)
      end
      problems.flatten
    end
  end
end
