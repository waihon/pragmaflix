describe "View a list of reviews" do
  it "shows the reviews for a specific movie" do
    # Arrange
    movie1 = Movie.create(movie_attributes(title: "Iron Man"))
    review1 = movie1.reviews.create(review_attributes(name: "Roger Ebert"))
    review2 = movie1.reviews.create(review_attributes(name: "Gene Siskel"))

    movie2 = Movie.create(movie_attributes(title: "Superman"))
    review3 = movie2.reviews.create(review_attributes(name: "Peter Travers"))

    # Action
    visit movie_reviews_url(movie1)

    # Assert
    expect(page).to have_text(review1.name)
    expect(page).to have_text(review2.name)
    expect(page).not_to have_text(review3.name)
  end
end