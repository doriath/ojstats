require './lib/online_judges/accept.rb'

module OnlineJudges
  class PolishSpoj
    class StatusPage
      def initialize(url, problem)
        @url = url
        @problem = problem
      end

      def attempts
        result = []
        page.css('tr').each do |row|
          status = row.css('td.statusres').text.strip
          next if status.empty?

          if status == 'zaakceptowano'
            status = 'AC'
          else
            status = 'WA'
          end

          result << OnlineJudges::Attempt.new(
            Time.parse(row.css('td.status_sm').text.strip),
            @problem,
            status)
        end
        result
      end

      def first_accept
        attempts.reverse.each do |attempt|
          if attempt.result == 'AC'
            return OnlineJudges::Accept.new(attempt.attempted_at, @problem)
          end
        end
        nil
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
