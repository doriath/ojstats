module OnlineJudges::Spoj
  # Represents page with problem statistics and best submissions.
  #
  # For polish spoj:
  # http://pl.spoj.pl/ranks/PROBLEM/
  #
  # For english spoj:
  # http://spoj.pl/ranks/PROBLEM/
  class ProblemPage
    def initialize(url)
      @url = url
    end

    # @return [Problem]
    def problem
      problem = OnlineJudges::Problem.new(problem_name, num_accepts)

      best_status = page.css('.statusres').first.text.strip
      if is_integer? best_status
        problem.best_points = best_status.to_i

        last_page = get_html_page(@url + "start=100000")
        worst_status = last_page.css('.statusres').last.text.strip

        problem.worst_points = worst_status.to_i
      end

      problem
    end

    private

    # @return [Integer,nil]
    def num_accepts
      convert_to_integer page.css('.lightrow td:nth-child(1)').text
    end

    def problem_name
      match_data = %r{ranks/(.*)/}.match(@url)
      match_data[1]
    end

    def page
      @page ||= get_html_page(@url)
    end

    def get_html_page(url)
      Nokogiri::HTML(Typhoeus::Request.get(url).body)
    end

    def is_integer?(str)
      str.match(/^\d+$/)
    end

    def convert_to_integer(str)
      str.to_i if is_integer?(str)
    end
  end
end
