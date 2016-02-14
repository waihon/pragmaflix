describe "Deleting a genre" do
  before do
    admin = User.create!(user_attributes(admin: true))
    sign_in(admin)
  end

  it "destroys the genre and shows the genre listing without the deleted genre" do
    # Arrange
    genre = Genre.create(genre_attributes)

    # Action
    visit genre_path(genre)
    click_link "Delete"

    # Assert
    expect(current_path).to eq(genres_path)
    expect(page).not_to have_text(genre.name)

    expect(page).to have_text("Genre successfully deleted!")
  end
end