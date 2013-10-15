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

      best_status = ""
      if page.css('.statusres').first
        best_status = page.css('.statusres').first.text.strip
      end

      if contains_number? best_status
        problem.best_points = convert_to_float best_status

        worst_status = last_page.css('.statusres').last.text.strip

        problem.worst_points = convert_to_float worst_status
      end

      problem.url = problem_description_url

      problem
    end

    private

    def convert_to_float str
      if str.match(/(\d+(\.\d+)?)/)
        $1.to_f
      else
        0.0
      end
    end

    # @return [Integer,nil]
    def num_accepts
      convert_to_integer page.css('.lightrow td:nth-child(1)').text
    end

    def problem_name
      match_data = %r{ranks/(.*)/}.match(@url)
      match_data[1]
    end

    # Returns url to problem page on judge website
    # @return [String]
    def  problem_description_url
      url = @url
      url.sub('ranks', 'problems')
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

    def contains_number?(str)
      str.match(/(\d+(\.\d+)?)/)
    end

    def convert_to_integer(str)
      str.to_i if is_integer?(str)
    end
  end
end
