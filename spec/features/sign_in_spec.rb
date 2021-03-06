describe "Signing in a user" do
  it "displays a Sign In form with email and password fields" do
    # Arrange - N/A

    # Action
    visit root_url
    click_link "Sign In"

    # Assert
    expect(current_path).to eq(signin_path)
    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
  end

  it "signs in the user if the email/password combination is valid" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    visit root_url
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"

    # Assert
    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Welcome back, #{user.name}!")

    expect(page).to have_link(user.name)
    expect(page).not_to have_link("Sign Up", signup_path)
    expect(page).not_to have_link("Sign In", signin_path)
    expect(page).to have_link("Sign Out")
  end

  it "does not sign in the user if the email/password combination is invalid" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    visit root_url
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: "no match"
    click_button "Sign In"

    # Assert
    # After the submission, a request will be posted to session path.
    # It won't remain at signin path even when there's any error.
    expect(current_path).to eq(session_path)
    expect(page).to have_text("Invalid email/username/password combination!")    

    expect(page).not_to have_link(user.name)
    expect(page).to have_link("Sign Up", signup_path)
    expect(page).to have_link("Sign In", signin_path)  
    expect(page).not_to have_link("Sign Out")  
  end

  it "redirects to the intended page" do
    user = User.create!(user_attributes)

    visit users_url

    expect(current_path).to eq(signin_path)

    sign_in(user)

    expect(current_path).to eq(users_path)
  end
end
