class JudgeResult
  # @return [String] the name of the online judge
  attr_reader :judge_name

  # @return [Float] the sum of scores of all problems solved
  attr_reader :score

  # @return [Integer] the number of solved problems
  attr_reader :num_problems

  def initialize judge_name, score, num_problems
    @judge_name = judge_name
    @score = score
    @num_problems = num_problems
  end
end
