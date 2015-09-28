module OnlineJudges
  class EnglishSpoj
    # Represents page with problem statistics and best submissions.
    #
    # For english spoj:
    # http://spoj.pl/ranks/PROBLEM/
    class ProblemPage
      def initialize(url)
        @url = url
      end

      # @return [Problem]
      def problem
        return OnlineJudges::Problem.new(problem_name, num_accepts, problem_description_url)
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
        convert_to_integer page.css('.lightrow .text-center:nth-child(1)').text
      end

      def problem_name
        match_data = %r{ranks/(.*)/}.match(@url)
        match_data[1]
      end

      # Returns url to problem page on judge website
      # @return [String]
      def problem_description_url
        url = @url
        url.sub('ranks', 'problems')
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

      def contains_number?(str)
        str.match(/(\d+(\.\d+)?)/)
      end

      def convert_to_integer(str)
        str.to_i if is_integer?(str)
      end
    end
  end
end
