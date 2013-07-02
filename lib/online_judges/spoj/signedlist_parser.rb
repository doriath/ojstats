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

    # @return [Array<Attempt>]
    def attempts
      @attempts ||= compute_attempts
    end

    private

    def compute_accepts
      accepted = {}
      submissions.each do |s|
        if s.result == "AC" or s.points
          points = s.points
          if accepted[s.problem]
            points = [points, accepted[s.problem].points].max
          end
          accepted[s.problem] = Accept.new(s.submitted_at, s.problem, points)
        end
      end
      accepted.values
    end

    # @note takes any score result as accepted
    def compute_attempts
      attempted = {}
      submissions.reverse.each do |s|
        if s.result == "AC" or s.points
          attempted[s.problem] = Attempt.new(s.submitted_at, s.problem, "AC")
        elsif (not attempted[s.problem]) or (attempted[s.problem].result != "AC")
          attempted[s.problem] = Attempt.new(s.submitted_at, s.problem, s.result)
        end
      end
      attempted.values.delete_if{ |a| a.result == "AC" }
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
        result.to_f if result.match(/^\d+(\.\d+)?$/)
      end

      private

      def self.problem_description_line? fields
        fields.size == 8 && fields[1].match(/^\d+$/)
      end
    end
  end
end
