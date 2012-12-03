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

      unless problem.num_accepts
        positions = last_page.css('.statustext:nth-child(1)')
        problem.num_accepts = positions.last.text.strip.to_i
      end

      best_status = page.css('.statusres').first.text.strip
      if is_integer? best_status
        problem.best_points = best_status.to_i

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

    def last_page
      @last_page ||= begin
        last = get_html_page(@url + "start=100000")
        if last.css('.statusres').empty?
          uri = URI(@url)
          last_url = uri.scheme + "://" + uri.host + last.css('.pager_link').last['href']
          get_html_page(last_url)
        else
          last
        end
      end
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
