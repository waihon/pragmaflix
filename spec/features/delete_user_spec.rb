describe "Deleting a user" do
  before do
    admin = User.create!(user_attributes(admin: true))
    sign_in(admin)
  end

  it "destroys the user and redirects to the home page" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    #visit user_path(user)
    #sign_in(user)
    click_link "Delete Account"

    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_text("Account successfully deleted!")

    # Action
    visit users_path
    expect(page).not_to have_text(user.name)
  end

  #it "destroys and signs out the user and redirects to the home page" do
  it "automatically signs out that user" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    #visit root_path
    #sign_in(user)

    visit user_path(user)
    click_link "Delete Account"

    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_text("Account successfully deleted!")
    expect(page).to have_link("Sign In")
    expect(page).to have_link("Sign Up")
    expect(page).not_to have_link("Sign Out")

    # Action
    visit users_path
    expect(page).not_to have_text(user.name)    
  end
end