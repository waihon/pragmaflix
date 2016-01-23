describe "Creating a new user" do
  it "saves the user and shows the user's profile page" do
    # Arrange
    visit root_url

    # Action
    click_link "Sign Up"

    # Assert
    expect(current_path).to eq(signup_path)

    # Action 
    fill_in "Name", with: "Example User"
    fill_in "Username", with: "example48"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "secretgarden"
    fill_in "Confirm Password", with: "secretgarden"
    click_button "Create Account"

    # Assert
    expect(current_path).to eq(user_path(User.last))
    expect(page).to have_text("Example User")
    expect(page).to have_text("Thanks for signing up!")
  end

  it "does not save the user if it's invalid" do
    visit signup_url

    expect {
      click_button "Create Account"
    }.not_to change(User, :count)

    expect(page).to have_text("error")
  end
end