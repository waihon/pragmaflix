describe "A genre" do
  it "with example attributes is valid" do
    # Arrange
    genre = Genre.new(genre_attributes)

    # Assert
    expect(genre.valid?).to eq(true)
  end

  it "requires a name" do
    # Arrange
    genre = Genre.new(name: "")

    # Action
    genre.valid?  # populate errors

    expect(genre.errors[:name].any?).to eq(true)
  end

  it "has many movies through characterizations" do
    # Arrange
    genre = Genre.create!(genre_attributes)

    movie1 = Movie.create!(movie_attributes(title: "Iron Man"))
    movie2 = Movie.create!(movie_attributes(title: "Iron Man 2"))
    movie3 = Movie.create!(movie_attributes(title: "Mr. Bean"))

    genre.movie_ids = [movie1.id, movie2.id]

    # Action - N/A

    # Assert
    expect(genre.movies).to include(movie1)
    expect(genre.movies).to include(movie2)
    expect(genre.movies).not_to include(movie3)
  end
end