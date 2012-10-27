Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password 'secret'
  display_name 'John Smith'
end
