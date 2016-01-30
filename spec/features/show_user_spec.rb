describe "Viewing a user's profile page" do
  it "shows the user's details" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    sign_in(user)
    
    visit user_url(user)

    # Assert
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end
end