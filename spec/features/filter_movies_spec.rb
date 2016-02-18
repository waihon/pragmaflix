describe "Filtering movies" do
  it "shows hit movies" do
    # Arrange
    movie1 = Movie.create!(movie_attributes(title: "Iron Man", released_on: 1.day.ago, total_gross: 300_000_000))
    movie2 = Movie.create!(movie_attributes(title: "Superman", released_on: 1.day.ago, total_gross: 299_999_999.99))

    # Action
    visit movies_url
    click_link "Hits"

    # Assert
    expect(current_path).to eq(filtered_movies_path(:hits))
    expect(page).to have_text(movie1.title)
    expect(page).not_to have_text(movie2.title)
  end

  it "shows flop movies" do
    # Arrange
    movie1 = Movie.create!(movie_attributes(title: "Iron Man", released_on: 1.day.ago, total_gross: 49_999_999.99))
    movie2 = Movie.create!(movie_attributes(title: "Superman", released_on: 1.day.ago, total_gross: 50_000_000))

    # Action
    visit movies_url
    click_link "Flops"

    # Assert
    expect(current_path).to eq(filtered_movies_path(:flops))
    expect(page).to have_text(movie1.title)
    expect(page).not_to have_text(movie2.title)
  end

  it "shows upcoming movies" do
    # Arrange
    movie1 = Movie.create!(movie_attributes(title: "Iron Man", released_on: 1.day.from_now))
    movie2 = Movie.create!(movie_attributes(title: "Superman", released_on: 1.day.ago))

    # Action
    visit movies_url
    click_link "Upcoming"

    # Assert
    expect(current_path).to eq(filtered_movies_path(:upcoming))
    expect(page).to have_text(movie1.title)
    expect(page).not_to have_text(movie2.title)
  end

  it "show recent movies" do
    # Arrange
    movie1 = Movie.create!(movie_attributes(title: "Iron Man", released_on: 1.day.ago, total_gross: 50_000_000))
    movie2 = Movie.create!(movie_attributes(title: "Superman", released_on: 1.day.from_now, total_gross: 50_000_000))
    movie3 = Movie.create!(movie_attributes(title: "Mr Bean", released_on: 1.day.ago, total_gross: 49_999_999.99))
    movie4 = Movie.create!(movie_attributes(title: "Ms Susan", released_on: 1.day.from_now, total_gross: 49_999_999.99))

    # Action
    visit movies_url
    click_link "Recent"

    # Assert
    expect(current_path).to eq(filtered_movies_path(:recent))
    expect(page).to have_text(movie1.title)
    expect(page).not_to have_text(movie2.title)
    expect(page).to have_text(movie3.title)
    expect(page).not_to have_text(movie4.title)
  end
end