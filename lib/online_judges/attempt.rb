module OnlineJudges
  # @param [Time] ateempted_at
  # @param [String] problem the name of the problem that was accepted
  # @param [String] result the result state of attemt (like WA, TLE, CE etc.)
  Attempt = Struct.new(:attempted_at, :problem, :result)
end
