require 'typhoeus'

module OnlineJudges
  class Spoj < SpojBase
    def url_base
      "http://www.spoj.pl"
    end

    # @example
    #
    # [{problem_name: 'FIB', num_accepts: 234},
    #  {problem_name: 'FIB1', num_accepts: 500}]
    #
    # @return [Array]
    def fetch_all_problems
      problems = []
      ['http://www.spoj.pl/problems/classical/'].each do |url|
        problems << fetch_all_problems_starting_from(url)
      end
      problems.flatten
    end
  end
end
