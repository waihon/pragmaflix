describe "Signing in a user" do
  it "displays a Sign In form with email and password fields" do
    # Arrange - N/A

    # Action
    visit root_url
    click_link "Sign In"

    # Assert
    expect(current_path).to eq(new_session_path)
    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
  end
end