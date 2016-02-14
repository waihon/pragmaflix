describe "Viewing the list of genres" do
  it "show the genres" do
    # Arrange
    genre1 = Genre.create(genre_attributes(name: "Action"))
    genre2 = Genre.create(genre_attributes(name: "Comedy"))
    genre3 = Genre.create(genre_attributes(name: "Thriller"))

    # Action
    visit genres_url

    # Assert
    expect(page).to have_text(genre1.name)
    expect(page).to have_text(genre2.name)
    expect(page).to have_text(genre3.name)
  end
end