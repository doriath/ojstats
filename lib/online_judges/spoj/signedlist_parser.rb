include OnlineJudges

module OnlineJudges::Spoj
  class SignedlistParser
    # @param [String] url
    def initialize url
      @url = url
    end

    # @return [Array<Accept>]
    def accepts
      @accepts ||= compute_accepts
    end

    private

    def compute_accepts
      accepted = {}
      submissions.each do |s|
        if s.result == "AC" or s.points
          accepted[s.problem] = Accept.new(s.submitted_at, s.problem, s.points)
        end
      end
      accepted.values
    end

    # @return [Array<Submission>]
    def submissions
      @submissions ||= compute_submissions
    end

    def compute_submissions
      page = Typhoeus::Request.get(@url).body
      parse_signedlist(page)
    end

    # @return [Array<Submission>]
    def parse_signedlist(signedlist)
      submits = []

      lines = signedlist.split("\n")
      lines.each do |line|
        submit = Submission.parse_line(line)
        submits << submit if submit
      end
      submits
    end

    Submission = Struct.new(:submitted_at, :problem, :result) do
      def self.parse_line line
        fields = line.split('|').map(&:strip)
        if problem_description_line? fields
          Submission.new(Time.zone.parse(fields[2]), fields[3], fields[4])
        end
      end

      def points
        result.to_i if result.match(/^\d+$/)
      end

      private

      def self.problem_description_line? fields
        fields.size == 8 && fields[1].match(/^\d+$/)
      end
    end
  end
end