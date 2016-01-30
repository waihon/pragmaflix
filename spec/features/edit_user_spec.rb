describe "Editing a user" do
  it "updates the user and show the user's updated details" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    #visit user_url(user)
    sign_in(user)
    click_link "Edit Account"

    # Assert
    expect(current_path).to eq(edit_user_path(user))
    expect(find_field("Name").value).to eq(user.name)

    # Action
    fill_in "Name", with: "Updated User Name"
    click_button "Update Account"

    # Assert
    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Updated User Name")
    expect(page).to have_text("Account successfully updated!")
  end

  it "does not update the user if it's invalid" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    #visit edit_user_url(user)
    sign_in(user)
    click_link "Edit Account"
    fill_in "Name", with: " "
    click_button "Update Account"

    # Assert
    expect(page).to have_text("error")
  end
end