def create_accept(user, problem)
  AcceptedProblem.create!(online_judge: problem.online_judge, user: user, problem: problem, score: problem.score, accepted_at: Time.zone.now - 5.days)
end

Given /^few users are registered and solved some problems$/ do
  problem1 = Fabricate(:problem, online_judge: 'spoj', score: 0.2)
  problem2 = Fabricate(:problem, online_judge: 'spoj', score: 0.9)
  problem3 = Fabricate(:problem, online_judge: 'plspoj', score: 0.15)
  problem4 = Fabricate(:problem, online_judge: 'plspoj', score: 0.6)
  user1 = Fabricate(:user, display_name: 'John Smith')
  user2 = Fabricate(:user, display_name: 'Other Guy')

  create_accept(user1, problem1)
  create_accept(user1, problem2)
  create_accept(user1, problem4)

  create_accept(user2, problem2)
end

When /^I go the the home page$/ do
  visit '/'
end

# Expected ranking:
# | John Smith | spoj 1.1(2) | plspoj 0.6(1) | total 1.85(3) |
# | Other Guy  | spoj 0.9(1) | plspoj 0.0(0) | total 0.9(1)  |
Then /^I should see the correct ranking with scores$/ do
  page.should have_content 'Ranking'
  rows = all('table tbody tr')
  rows[0].should have_content '1 John Smith 1.1 (2) 0.6 (1) 1.7 (3)'
  rows[1].should have_content '2 Other Guy 0.9 (1) 0 0.9 (1)'
end

Given /^I am logged in$/ do
  @current_user = Fabricate(:user, email: 'test@example.com', password: 'secret')
  visit new_user_session_url
  fill_in 'Email', with: 'test@example.com'
  fill_in 'Password', with: 'secret'
  click_button 'Sign in'
end
