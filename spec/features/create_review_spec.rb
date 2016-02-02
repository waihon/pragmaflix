describe "Creating a new review" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "saves the review" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Action
    visit movie_url(movie)
    click_link "Write Review"

    # Assert
    expect(current_path).to eq(new_movie_review_path(movie))

    # Action

    # Name is part of the signed in user
    #fill_in "Name", with: "Roger Ebert"
    # Change Review Stars from a dropdown to radio buttons
    #select 3, from: "review_stars"
    choose "review_stars_3"
    fill_in "Comment", with: "I laughed, I cried, I spilled my popcorn!"
    fill_in "Location", with: "Dallas, TX"
    click_button "Create Review"

    expect(current_path).to eq(movie_reviews_path(movie))
    expect(page).to have_text("Thanks for your review!")
    expect(page).to have_text(@user.name)
  end

  it "does not save the review if it's invalid" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Action
    visit new_movie_review_path(movie)

    # Assert
    expect {
      click_button "Create Review"
    }.not_to change(Review, :count)
    expect(page).to have_text("error")
  end
end