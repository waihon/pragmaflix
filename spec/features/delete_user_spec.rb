describe "Deleting a user" do
  it "destroys the user and redirects to the home page" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    visit user_path(user)
    click_link "Delete Account"

    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_text("Account successfully deleted!")

    # Action
    visit users_path
    expect(page).not_to have_text(user.name)
  end
end