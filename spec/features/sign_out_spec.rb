describe "Signing out" do
  #it "displays home page with Sign Up and Sign In links" do
  it "removes the user id from the session" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    sign_in(user)
    click_link "Sign Out"

    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_text("signed out")
    expect(page).to have_link("Sign In")
    expect(page).to have_link("Sign Up")
    expect(page).not_to have_link("Sign Out")
  end
end