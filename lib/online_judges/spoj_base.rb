require 'typhoeus'

module OnlineJudges
  Problem = Struct.new(:name, :num_accepts, :best_points, :worst_points)
  Accept = Struct.new(:accepted_at, :problem, :points)

  class ProblemsPage
    def initialize(url)
      @url = url
    end

    def has_next?
      !!next_url
    end

    def next_url
      page.css('.pager_link').each do |link|
        if link.text == 'Next' or link.text == 'Dalej'
          uri = URI(@url)
          return uri.scheme + "://" + uri.host + link[:href]
        end
      end
      nil
    end

    # @return [Array<Problem>]
    def problems
      names = page.css('.problemrow td:nth-child(3) a')
      num_accepts = page.css('.problemrow td:nth-child(4) a')
      names.zip(num_accepts).map do |name, num_accepts|
        Problem.new(name.text.strip, num_accepts.text.strip.to_i)
      end
    end

    private

    def page
      @page ||= get_html_page(@url)
    end

    def get_html_page(url)
      Nokogiri::HTML(get_page(url))
    end

    def get_page(url)
      Typhoeus::Request.get(url).body
    end
  end

  class SpojBase
    # @example
    #
    # [{accepted_at: Time.now, problem: 'FIB'},
    #  {accepted_at: Time.now, problem: 'FIB1', points: 20}]
    #
    # @param [String] user_name
    # @return [Array<Accept>]
    def fetch_accepted_problems(user_name)
      submissions = fetch_submissions(user_name)
      accepted = {}
      submissions.each do |submission|
        if submission[:result] == "AC"
          accepted[submission[:problem]] =
            Accept.new(submission[:submitted_at], submission[:problem])
        end
      end
      accepted.values
    end

    # @example
    #
    # {problem_name: 'FIB', num_accepts: 234},
    #
    # @param [String] problem_name
    # @return [Problem]
    def fetch_problem(problem_name)
      problem = Problem.new(problem_name)

      url = "#{url_base}/ranks/#{problem_name}/"
      page = get_html_page(url)

      problem.num_accepts = convert_to_integer(
        page.css('.lightrow td:nth-child(1)').text)

      best_status = page.css('.statusres').first.text.strip
      if is_integer? best_status
        problem.best_points = best_status.to_i

        last_page = get_html_page(url + "start=100000")
        worst_status = last_page.css('.statusres').last.text.strip

        problem.worst_points = worst_status.to_i
      end

      problem
    end

    private

    def fetch_all_problems_starting_from(url)
      problems = []
      page = ProblemsPage.new(url)
      loop do
        problems = problems.concat page.problems
        break unless page.has_next?
        page = ProblemsPage.new(page.next_url)
      end
      problems
    end

    def get_html_page(url)
      Nokogiri::HTML(get_page(url))
    end

    def get_page(url)
      Typhoeus::Request.get(url).body
    end

    def is_integer?(str)
      str.to_i.to_s == str
    end

    def convert_to_integer(str)
      if is_integer?(str)
        str.to_i
      end
    end

    def fetch_submissions(user_name)
      parse_signedlist fetch_signedlist user_name
    end

    def fetch_signedlist(user_name)
      get_page "#{url_base}/status/#{user_name}/signedlist/"
    end

    def parse_signedlist(signedlist)
      submits = []

      lines = signedlist.split("\n")
      lines.each do |line|
        submit = parse_line(line)
        submits << submit if submit
      end
      submits
    end

    def parse_line line
      fields = line.split('|').map(&:strip)
      if problem_description_line? fields
        {
          id: fields[1].to_i,
          submitted_at: Time.zone.parse(fields[2]),
          problem: fields[3],
          result: fields[4],
          time: fields[5].to_f,
          memory: fields[6].to_i,
          language: fields[7]
        }
      end
    end

    def problem_description_line? fields
      fields.size == 8 && fields[1].match(/^\d+$/)
    end
  end
end
