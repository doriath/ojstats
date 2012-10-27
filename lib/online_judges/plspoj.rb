require 'typhoeus'

module OnlineJudges
  class Plspoj < SpojBase
    def url_base
      "http://pl.spoj.pl"
    end
  end
end
