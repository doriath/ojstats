require './lib/online_judges/accept.rb'

module OnlineJudges
  class EnglishSpoj
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

          if row.css('td.statusres').attr('status').value == "15"
            if status.to_i.to_s == status
              status = status.to_i
            else
              status = 'AC'
            end
          end

          result << OnlineJudges::Attempt.new(
            Time.parse(row.css('td.status_sm').text.strip),
            @problem,
            status)
        end
        result
      end

      def first_accept
        max_points = nil
        attempts.reverse.each do |attempt|
          if attempt.result == 'AC'
            return OnlineJudges::Accept.new(attempt.attempted_at, @problem)
          end
          if attempt.result.to_i == attempt.result
            if max_points.nil? || max_points.points < attempt.result
              max_points = OnlineJudges::Accept.new(attempt.attempted_at, @problem, attempt.result)
            end
          end
        end
        max_points
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
