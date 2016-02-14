describe "Navigating genres" do
  it "allows navigation from the detail page to the listing page" do
    # Arrange
    genre = Genre.create!(genre_attributes)

    # Action
    visit genre_url(genre)
    click_link "All Genres"

    # Assert
    expect(current_path).to eq(genres_path)
  end

  it "allows javigation from the listing page to the detail page" do
    # Arrange
    genre = Genre.create!(genre_attributes)

    # Action
    visit genres_url
    click_link genre.name

    # Assert
    expect(current_path).to eq(genre_path(genre))
  end
end