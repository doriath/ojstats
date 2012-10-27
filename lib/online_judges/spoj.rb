require 'typhoeus'

module OnlineJudges
  class Spoj < SpojBase
    def url_base
      "http://www.spoj.pl"
    end
  end
end
