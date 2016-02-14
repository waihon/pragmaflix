describe "Editing a genre" do
  before do
    admin = User.create!(user_attributes(admin: true))
    sign_in(admin)
  end

  it "updates the genre and shows the genre's updated details" do
    # Arrange
    genre = Genre.create!(genre_attributes)

    # Action
    visit genre_url(genre)
    click_link "Edit"

    # Assert
    expect(current_path).to eq(edit_genre_path(genre))
    expect(find_field("Name").value).to eq(genre.name)

    # Action
    fill_in "Name", with: "Updated Genre Name"
    click_button "Update Genre"

    # Assert
    expect(current_path).to eq(genre_path(genre))
    expect(page).to have_text("Updated Genre Name")
    expect(page).to have_text("Genre successfully updated!")
  end

  it "does not save the genre if it's invalid" do
    # Arrange
    genre = Genre.create(genre_attributes)

    # Action
    visit edit_genre_path(genre)
    fill_in "Name", with: ""

    # Assert
    expect {
      click_button "Update Genre"
    }.not_to change(Genre, :count)

    expect(current_path).to eq(genre_path(genre))
    expect(page).to have_text("error")
  end
end