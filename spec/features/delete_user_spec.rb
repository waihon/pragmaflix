describe "Deleting a user" do
  before do
    admin = User.create!(user_attributes(username: "admin", email: "admin@example.com", 
                                         admin: true))
    sign_in(admin)
    @user = User.create!(user_attributes(name: "Regular User", username: "regularuser", 
                                         email: "regularuser@example.com"))
  end

  it "destroys the user and redirects to the home page" do
    # Arrange - N/A

    # Action
    visit user_path(@user)
    click_link "Delete Account"

    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_text("Account successfully deleted!")

    # Action
    visit users_path
    expect(page).not_to have_text(@user.name)
  end

  # Only Admin Users can delate another user so do not automatically 
  # sign out the Admin User involved
  #it "automatically signs out that user" do
  it "does not automatically sign out the Admin User" do
    # Arrange - N/A

    # Action
    visit user_path(@user)
    click_link "Delete Account"

    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_text("Account successfully deleted!")
    expect(page).not_to have_link("Sign In")
    expect(page).not_to have_link("Sign Up")
    expect(page).to have_link("Sign Out")

    # Action
    visit users_path
    expect(page).not_to have_text(@user.name)    
  end
end