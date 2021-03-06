describe "A user" do
  it "requires a name" do
    # Arrange
    user = User.new(name: "")

    user.valid? # populates errors

    # Assert
    expect(user.errors[:name].any?).to eq(true)
  end

  it "requires an email" do
    user = User.new(email: "")

    user.valid?

    expect(user.errors[:email].any?).to eq(true)
  end

  it "accepts properly formatted email addresses" do
    emails = %w[user@example.com first.last@example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(false)
    end
  end

  it "rejects improperly formatted email addresses" do
    emails = %w[@ user@ @example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(true)
    end
  end

  it "requires a unique, case insensitive email address" do
    user1 = User.create!(user_attributes)

    user2 = User.new(email: user1.email.upcase)
    user2.valid?
    expect(user2.errors[:email].first).to eq("has already been taken")
  end

  it "is valid with example attributes" do
    user = User.new(user_attributes)

    expect(user.valid?).to eq(true)
  end

  it "requires a password" do
    user = User.new(password: "")

    user.valid?

    expect(user.errors[:password].any?).to eq(true)
  end

  it "requires a password confirmation when a password is present" do
    user = User.new(password: "secretgarden", password_confirmation: "")

    user.valid?

    expect(user.errors[:password_confirmation].any?).to eq(true)
  end

  it "requires the password to match the password confirmation" do
    user = User.new(password: "secretgarden", password_confirmation: "nomatch")

    user.valid?

    expect(user.errors[:password_confirmation].first).to eq("doesn't match Password")
  end

  it "requires a password and matching password confirmation when creating" do
    user = User.create!(user_attributes(password: "secretgarden", password_confirmation: "secretgarden"))

    expect(user.valid?).to eq(true)
  end

  it "does not require a password when updating" do
    user = User.create!(user_attributes)

    user.password = ""

    expect(user.valid?).to eq(true)
  end

  it "automatically encrypts the password into the password_digest attribute" do
    user = User.new(password: "secretgarden")

    expect(user.password_digest.present?).to eq(true)
  end

  it "requires a password with a minimum lenght of 10" do
    # Arrange
    user1 = User.new(password: "x" * 9)
    user2 = User.new(password: "y" * 10)

    # Action
    user1.valid?
    user2.valid?

    # Assert
    expect(user1.errors[:password].any?).to eq(true)
    expect(user2.errors[:password].any?).to eq(false)
  end

  it "requires a username" do
    # Arrange
    user = User.new(username: "")

    # Action
    user.valid?

    # Assert
    expect(user.errors[:username].any?).to eq(true)
  end

  it "accepts a username that only consists of letters and numbers without spaces" do
    # Arrange
    user = User.new(username: "larryk48")

    # Action
    user.valid?

    # Assert
    expect(user.errors[:username].any?).to eq(false)
  end

  it "rejects a username that contains spaces" do
    # Arrange
    user = User.new(username: "larryk 48")

    # Action
    user.valid?

    # Assert
    expect(user.errors[:username].any?).to eq(true)
  end

  it "rejects a username that non alphanumeric characters" do
    # Arrange
    user = User.new(username: "larryk.48")

    # Action
    user.valid?

    # Assert
    expect(user.errors[:username].any?).to eq(true)
  end

  it "requires a unique, case insensitive username" do
    # Arrange
    user1 = User.create!(user_attributes)
    user2 = User.new(username: user1.username.upcase) # case insensitive

    # Action
    user2.valid?

    # Assert
    expect(user2.errors[:username].first).to eq("has already been taken")    
  end

  # Own example
  it "has many reviews" do
    # Arrange
    user = User.create!(user_attributes)
    movie1 = Movie.create!(movie_attributes(title: "Movie 1"))
    movie2 = Movie.create!(movie_attributes(title: "Movie 2"))
    movie3 = Movie.create!(movie_attributes(title: "Movie 3"))
    review1 = Review.create!(review_attributes(user_id: user.id, movie_id: movie1.id))
    review2 = Review.create!(review_attributes(user_id: user.id, movie_id: movie2.id))
    review3 = Review.create!(review_attributes(user_id: user.id, movie_id: movie3.id))

    # Action - N/A

    # Assert
    expect(user.reviews).to include(review1)
    expect(user.reviews).to include(review2)
    expect(user.reviews).to include(review3)
  end

  # The instructor's example
  it "has reviews" do
    user = User.new(user_attributes)
    movie1 = Movie.new(movie_attributes(title: "Iron Man"))
    movie2 = Movie.new(movie_attributes(title: "Superman"))

    review1 = movie1.reviews.new(location: "Texas", stars: 5, comment: "Two thumbs up!")
    review1.user = user
    review1.save!

    review2 = movie2.reviews.new(location: "New York", stars: 3, comment: "Cool!")
    review2.user = user
    review2.save!

    expect(user.reviews).to include(review1)
    expect(user.reviews).to include(review2)
  end
end

describe "authenticate" do
  before do
    # Arrange
    @user = User.create!(user_attributes)
  end

  it "authenticates a user with valid email/password combination" do
    # Assert
    expect(User.authenticate(@user.email, @user.password)).to eq(@user)
  end

  it "authenticates a user with valid username/password combination" do
    # Assert
    expect(User.authenticate(@user.username, @user.password)).to eq(@user)
  end

  it "does not authenticate a user with invalid email/password combination" do
    # Assert
    expect(User.authenticate(@user.email, "no match")).to eq(false)
  end

  it "does not authenticate a user with invalid username/password combination" do
    # Assert
    expect(User.authenticate(@user.username, "no match")).to eq(false)
  end

  it "returns non-true value if the email does not match" do
    expect(User.authenticate("nomatch@example.com", @user.password)).not_to eq(true)
  end

  it "returns non-true value if the username does not match" do
    expect(User.authenticate("nomatch", @user.password)).not_to eq(true)
  end

  it "returns non-true value if the password does not match that of a valid email" do
    expect(User.authenticate(@user.email, "nomatch")).not_to eq(true)
  end

  it "returns non-true value if the password does not match that of a valid username" do
    expect(User.authenticate(@user.username, "nomatch")).not_to eq(true)
  end

  it "returns the user if the email and password match" do
    expect(User.authenticate(@user.email, @user.password)).to eq(@user)
  end

  it "returns the user if the case insensitive email and password match" do
    expect(User.authenticate(@user.email.upcase, @user.password)).to eq(@user)
  end

  it "returns the user if the username and password match" do
    expect(User.authenticate(@user.username, @user.password)).to eq(@user)
  end

  it "returns the user if the case insensitive username and password match" do
    expect(User.authenticate(@user.username.upcase, @user.password)).to eq(@user)
  end

  it "has favorite movies" do
    user = User.new(user_attributes(username: "larry", email: "larry@example.com"))
    movie1 = Movie.new(movie_attributes(title: "Iron Man"))
    movie2 = Movie.new(movie_attributes(title: "Spider-Man"))
    user.favorites.new(movie: movie1)
    user.favorites.new(movie: movie2)

    expect(user.favorite_movies).to include(movie1)
    expect(user.favorite_movies).to include(movie2)
  end
end