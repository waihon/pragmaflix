describe "Creating a new genre" do
  before do
    admin = User.create!(user_attributes(admin: true))
    sign_in(admin)
  end  

  it "saves the genre and show the new genre's details" do
    # Arrange - N/A

    # Action
    visit root_url
    click_link "Add New Genre"

    # Assert
    expect(current_path).to eq(new_genre_path)
    expect(find_field("Name").value).to eq(nil)

    # Action
    fill_in "Name", with: "Action"
    click_button "Create Genre"

    # Assert
    expect(current_path).to eq(genre_path(Genre.last))
    expect(page).to have_text("Action")
  end

  it "does not create an invalid genre" do
    # Arrange - N/A

    # Action
    visit root_url
    click_link "Add New Genre"

    # Assert
    expect(current_path).to eq(new_genre_path)
    expect(find_field("Name").value).to eq (nil)

    # Action
    fill_in "Name", with: ""
    click_button "Create Genre"

    # Assert
    expect(current_path).to eq(genres_path)
    expect(page).to have_text("error")
  end

  # Course instructor's feature spec
  it "does not save the movie if it's invalid" do
    # Arrange - N/A

    # Action
    visit new_genre_url

    # Assert
    expect {
      click_button "Create Genre"
    }.not_to change(Genre, :count)

    expect(current_path).to eq(genres_path)
    expect(page).to have_text("error")
  end
end