require 'typhoeus'

module OnlineJudges
  class Spoj
    def fetch_submissions(user_name)
      parse_signedlist fetch_signedlist user_name
    end

    def fetch_accepted_problems(user_name)
      submissions = fetch_submissions(user_name)
      accepted = {}
      submissions.each do |submission|
        if submission[:result] == "AC"
          accepted[submission[:problem]] = {
            accepted_at: submission[:submitted_at],
            problem: submission[:problem]
          }
        end
      end
      accepted.values
    end

    def fetch_signedlist(user_name)
      Typhoeus::Request.get("http://www.spoj.pl/status/#{user_name}/signedlist/").body
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
      if fields.size == 8 && fields[1].to_i.to_s == fields[1]
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
  end
end
