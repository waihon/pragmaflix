describe "Unfavoring a movie" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "deletes the favorite and shows the Fave button" do
    # Arrange
    movie = Movie.create!(movie_attributes)

    # Action
    visit movie_url(movie)
    click_button "Fave"

    # Assert
    expect(page).to have_text("1 fan")

    expect {
      click_button "Unfave"
    }.to change(@user.favorites, :count).by(-1)

    expect(page).to have_text("Sorry you unfaved it!")
    #expect(page).to have_text("0 fans")
    expect(page).to have_button("Fave")
  end
end