describe "A movie" do
  it "is a flop if the total gross is less than $50M" do
    # Arrange
    movie = Movie.new(total_gross: 49_999_999.99)

    # Assert
    expect(movie.flop?).to eq(true)
  end

  it "is not a flop if the total gross is $50M or more" do
    # Arrange
    movie = Movie.new(total_gross: 50_000_000.00)

    # Assert
    expect(movie.flop?).to eq(false)
  end

  it "is a flop if it is not a cult classic and the total gross is less than $50M" do
    # Arrange
    # Movie with 50 reviews or less even with average stars of 4 or or better
    movie1 = Movie.create(movie_attributes(total_gross: 49_999_999.99))
    50.times do
      movie1.reviews.create(review_attributes(stars: 4))
    end
    
    # Movie with more than 50 reviews but iwht average stars of worse than 4
    movie2 = Movie.create(movie_attributes(total_gross: 49_999_999.99))
    51.times do
      movie2.reviews.create(review_attributes(stars: 3.99))
    end

    # Assert
    expect(movie1.flop?).to eq(true)
    expect(movie2.flop?).to eq(true)
  end

  it "is not a flop if it is a cult classic regardless of the total gross" do
    # Arrange
    # Movie that has more than 51 reviews and with average stars of 4 or better
    # but with total gross of less than $50M
    movie1 = Movie.create(movie_attributes(total_gross: 49_999_999.99))
    review = movie1.reviews.create(review_attributes(stars: 4, name: "Mary Jane"))
    50.times do
      movie1.reviews.create(review_attributes(stars: 4))
    end
    #review.destroy

    # Movie that has more than 51 reviews and with average stars of 4 or better
    # and with total gross of $50M or more
    movie2 = Movie.create(movie_attributes(total_gross: 50_000_000.00))
    51.times do
      movie2.reviews.create(review_attributes(stars: 4))
    end

    # Assert
    expect(movie1.flop?).to eq(false)
    expect(movie2.flop?).to eq(false)
  end

  it "is released when the released date is in the past" do
    # Arrange
    movie = Movie.create(movie_attributes(released_on: 1.day.ago))

    # Assert
    expect(Movie.released).to include(movie)
  end

  it "is not released when the release date is in the future" do
    # Arrange
    movie = Movie.create(movie_attributes(released_on: 1.day.from_now))

    # Assert
    expect(Movie.released).not_to include(movie)
  end

  it "is at the top of the list of released movies if it is released most recently" do
    # Arrange
    movie1 = Movie.create(movie_attributes(title: "Movie 1", released_on: 2.years.ago))
    movie2 = Movie.create(movie_attributes(title: "Movie 2", released_on: 6.months.from_now))
    movie3 = Movie.create(movie_attributes(title: "Movie 3", released_on: 1.month.ago))
    movie4 = Movie.create(movie_attributes(title: "Movie 4", released_on: 3.years.ago))
    movies = Movie.released

    # Assert
    expect(movies.first).to eq(movie3)
  end

  it "is not at the top of the list of released movies if it is not released most recently" do
    # Arrange
    movie1 = Movie.create(movie_attributes(title: "Movie 1", released_on: 2.years.ago))
    movie2 = Movie.create(movie_attributes(title: "Movie 2", released_on: 6.months.from_now))
    movie3 = Movie.create(movie_attributes(title: "Movie 3", released_on: 1.month.ago))
    movie4 = Movie.create(movie_attributes(title: "Movie 4", released_on: 3.years.ago))
    movies = Movie.released

    # Assert
    expect(movies.first).not_to eq(movie1)
    expect(movies.first).not_to eq(movie2)
    expect(movies.first).not_to eq(movie4)
  end

  # Code examples from the course instructor
  it "returns released movies ordered with the most recently-released movie first" do
    # Arrange
    movie1 = Movie.create(movie_attributes(released_on: 3.months.ago))
    movie2 = Movie.create(movie_attributes(released_on: 2.months.ago))
    movie3 = Movie.create(movie_attributes(released_on: 1.month.ago))

    # Assert
    expect(Movie.released).to eq([movie3, movie2, movie1])
  end

  it "requires a title" do
    # Arrange
    movie = Movie.new(title: "")

    # Action
    movie.valid?  # populates errors

    # Assert
    expect(movie.errors[:title].any?).to eq(true)
  end

  it "requires a description" do
    # Arrange
    movie = Movie.new(description: "")

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:description].any?).to eq(true)
  end

  it "requires a released on date" do
    # Arrange
    movie = Movie.new(released_on: "")

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:released_on].any?).to eq(true)
  end

  it "requires a duration" do
    # Arrange
    movie = Movie.new(duration: "")

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:duration].any?).to eq(true)
  end

  it "requires a description over 24 characters" do
    # Arrange
    movie = Movie.new(description: "X" * 24)

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:description].any?).to eq(true)
  end

  it "accepts a $0 total gross" do
    # Arrange
    movie = Movie.new(total_gross: 0.00)

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it "accepts a positive total gross" do
    # Arrange
    movie = Movie.new(total_gross: 10_000_000.00)

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it "rejects a negative total gross" do
    # Arrange
    movie = Movie.new(total_gross: -10_000_000.00)

    # Action
    movie.valid?

    # Assert
    expect(movie.errors[:total_gross].any?).to eq(true)
  end

  # Paperclip will manage its image attribute
  # it "accepts properly formatted image file names" do
  #   file_names = %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF]
  #   file_names.each do |file_name|
  #     movie = Movie.new(image_file_name: file_name)
  #     movie.valid?
  #     expect(movie.errors[:image_file_name].any?).to eq(false)
  #   end
  # end

  # it "rejects improperly formatted image file names" do
  #   file_names = %w[movie .jpg .png .gif movie.pdf movie.doc]
  #   file_names.each do |file_name|
  #     movie = Movie.new(image_file_name: file_name)
  #     movie.valid?
  #     expect(movie.errors[:image_file_name].any?).to eq(true)
  #   end
  # end

  it "accepts any rating that is in an approved list" do
    ratings = %w[G PG PG-13 R NC-17]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(false)
    end
  end

  it "rejects any rating that is not in the approved list" do
    ratings = %w[R-13 R-16 R-18 R-21]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(true)
    end
  end

  it "is valid with example attributes" do
    movie = Movie.new(movie_attributes)

    expect(movie.valid?).to eq(true)
  end

  it "has many reviews" do
    movie = Movie.new(movie_attributes)

    review1 = movie.reviews.new(review_attributes)
    review2 = movie.reviews.new(review_attributes)

    expect(movie.reviews).to include(review1)
    expect(movie.reviews).to include(review2)
  end

  it "deletes associated reviews" do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes)

    expect {
      movie.destroy
    }.to change(Review, :count).by(-1)
  end

  it "calculates the average number of review stars" do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes(stars: 1))
    movie.reviews.create(review_attributes(stars: 3))
    movie.reviews.create(review_attributes(stars: 5))

    expect(movie.average_stars).to eq(3)
  end
end