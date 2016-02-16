describe "Viewing a user's profile page" do
  it "shows the user's details" do
    # Arrange
    user = User.create!(user_attributes)

    # Action
    sign_in(user)
    
    visit user_url(user)

    # Assert
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it "shows the user's favorite movies in the sidebar" do
    # Arrange
    user = User.create!(user_attributes)
    movie1 = Movie.create(movie_attributes(title: "Iron Man"))
    movie2 = Movie.create(movie_attributes(title: "Iron Man 2"))
    movie3 = Movie.create(movie_attributes(title: "Mr. Bean"))
    user.favorite_movies << movie1
    user.favorite_movies << movie2

    # Action
    sign_in(user)
    visit user_url(user)

    # Assert
    within("aside#sidebar") do
      expect(page).to have_text(movie1.title)
      expect(page).to have_text(movie2.title)
      expect(page).not_to have_text(movie3.title)
    end
  end

  it "show the user's name in the page title" do
    # Arrange
    user = User.create!(user_attributes(name: "Joe Doe"))

    # Action
    sign_in(user)
    visit user_url(user)

    # Assert
    expect(page).to have_title("Flix - #{user.name}")
  end
end