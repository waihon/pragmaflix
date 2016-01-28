describe "Signing Up" do
  it "signs in the user immediately after the sign-up process is successful" do
    # Arrange - N/A

    # Action
    visit root_url
    click_link "Sign Up"
    fill_in "Name", with: "Joe Doe"
    fill_in "Username", with: "joedoe"
    fill_in "Email", with: "joedoe@example.com"
    fill_in "Password", with: "secretgarden"
    fill_in "Confirm Password", with: "secretgarden"
    click_button "Create Account"

    # Assert
    user = User.last
    expect(current_path).to eq(user_path(user))
    expect(page).to have_link(user.name)
    expect(page).not_to have_link("Sign In")
    expect(page).not_to have_link("Sign Up")
  end
end