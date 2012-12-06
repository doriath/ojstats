Fabricator(:problem) do
  name { sequence(:problem_name) { |i| "problem_#{i}" } }
  online_judge 'spoj'
  score 1
  num_accepts 100
end
