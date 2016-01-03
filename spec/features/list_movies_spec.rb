#require "spec_helper"

describe "Viewing the list of movies" do
  it "show the movies" do
    # Arrange
    movie1 = Movie.create(title: "Iron Man",
                          rating: "PG-13",
                          total_gross: 318_412_101.00,
                          description: "Tony Stark builds an armored suit to fight the throes of evil",
                          released_on: "2008-05-02",
                          cast: "Robert Downey Jr., Gwyneth Paltrow and Terrence Howard",
                          director: "Jon Favreau",
                          duration: "126 min",
                          image_file_name: "ironman.jpg")

    movie2 = Movie.create(title: "Superman",
                          rating: "PG",
                          total_gross: 134_218_018.00,
                          description: "Clark Kent grows up to be the greatest super-hero",
                          released_on: "1978-12-15",
                          cast: "Christopher Reeve, Margot Kidder and Gene Hackman",
                          director: "Richard Donner",
                          duration: "143 min",
                          image_file_name: "")

    movie3 = Movie.create(title: "Spider-Man",
                          rating: "PG-13",
                          total_gross: 403_706_375.00,
                          description: "Peter Parker gets bit by a genetically modified spider",
                          released_on: "2002-05-03",
                          cast: "Tobey Maguire, Kirsten Dunst and Willem Dafoe",
                          director: "Sam Raimi",
                          duration: "121 min",
                          image_file_name: "spiderman.jpg")

    # Action
    visit movies_url

    # Assert
    #expect(page).to have_text("3 Movies")
    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie2.title)
    expect(page).to have_text(movie3.title)

    expect(page).to have_text(movie1.rating)
    expect(page).to have_text(movie1.description[0..9])
    expect(page).to have_text(movie1.released_on.year)
    expect(page).to have_text("$318,412,101.00")  
    expect(page).to have_text(movie1.cast)
    expect(page).to have_text(movie1.duration)  
    expect(page).to have_selector("img[src$='#{movie1.image_file_name}']")
  end

  it "show movies that have already been released" do
    # Arrange
    movie1 = Movie.create(movie_attributes(title: "Movie 1", released_on: 2.years.ago))
    movie2 = Movie.create(movie_attributes(title: "Movie 2", released_on: 6.months.from_now))
    movie3 = Movie.create(movie_attributes(title: "Movie 3", released_on: 1.month.ago))
    movie4 = Movie.create(movie_attributes(title: "Movie 4", released_on: 3.years.ago))

    # Action
    visit movies_path

    # Assert
    expect(page).to have_text(movie1.title)
    expect(page).not_to have_text(movie2.title)
    expect(page).to have_text(movie3.title)
    expect(page).to have_text(movie4.title)
  end

  # Spec by the course instructor
  it "does not show a movie that hasn't yet been released" do
    # Arrange
    movie = Movie.create(movie_attributes(released_on: 1.month.from_now))

    # Action
    visit movies_path

    # Assert
    expect(page).not_to have_text(movie.title)
  end  
end