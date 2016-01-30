def sign_in(user)
  visit root_url
  click_link "Sign In"
  fill_in "Email/Username", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end