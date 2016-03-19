require './lib/online_judges/accept.rb'

module OnlineJudges
  class PolishSpoj
    class UserPage
      def initialize(url)
        @url = url
      end

      def solved_problems
        result = []
        tables = page.css('.table-condensed')
        return [] if tables.size < 2
        tables[0].css('a').each do |solved_problem|
          next if solved_problem.text.empty?
          result << solved_problem.text.strip
        end
        result
      end

      private

      def page
        @page ||= get_html_page(@url)
      end

      def get_html_page(url)
        Nokogiri::HTML(Typhoeus::Request.get(url).body)
      end
    end
  end
end
