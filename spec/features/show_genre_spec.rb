describe "Viewing an individual genre" do
  before do
    @genre = Genre.create!(genre_attributes(name: "Thriller"))
  end

  it "show the genre's details" do
    # Arrange - N/A

    # Action
    visit genre_url(@genre)

    # Assert
    expect(current_path).to eq(genre_path(@genre))
    expect(page).to have_text(@genre.name)
  end

  it "lists the movies in the genre" do
    # Arrange
    movie1 = Movie.create!(movie_attributes(title: "Iron Man"))
    movie2 = Movie.create!(movie_attributes(title: "Iron Man 2"))
    movie3 = Movie.create!(movie_attributes(title: "Mr. Bean"))

    @genre.movies << movie1
    @genre.movies << movie2

    # Action
    visit genre_url(@genre)

    # Assert
    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie2.title)
    expect(page).not_to have_text(movie3.title)
  end
end