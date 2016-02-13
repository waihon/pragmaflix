describe "Creating a new movie" do
  before do
    admin = User.create(user_attributes(admin: true))
    sign_in(admin)
    @genre1 = Genre.create!(name: "Action")
    @genre2 = Genre.create!(name: "Comedy")
    @genre3 = Genre.create!(name: "Thriller")
  end

  it "saves the movie and shows the new movie's details" do
    # Action
    visit movies_url
    click_link "Add New Movie"

    # Assert
    expect(current_path).to eq(new_movie_path)
    expect(find_field("Title").value).to eq(nil)

    # Action
    fill_in "Title", with: "New Movie Title"
    fill_in "Description", with: "Superheroes saving the world from villains"
    #fill_in "Rating", with: "PG-13"
    select "PG-13", from: "movie_rating"
    fill_in "Total gross", with: "123_456_789"

    select (Time.now.year - 1).to_s, from: "movie_released_on_1i"
    # To take advantage of the HTML 5 date field in Chrome,
    # we'll need to use 'fill_in" rather than 'select'
    # fill_in "Released on", with: (Time.now.year - 1).to_s

    fill_in "Cast", with: "The award-winning cast"
    fill_in "Director", with: "The ever-creative director"
    fill_in "Duration", with: "123 min"
    # Using Paperclip gem to allow users to select a movie image file on 
    # their computer and upload it to the server.
    #fill_in "Image file name", with: "movie.png"
    attach_file "Image", "#{Rails.root}/app/assets/images/movie.jpg"

    check @genre1.name
    check @genre2.name

    click_button "Create Movie"

    # Assert
    expect(current_path).to eq(movie_path(Movie.last))

    expect(page).to have_text("New Movie Title")
    expect(page).to have_text("Superheroes saving the world from villains")
    expect(page).to have_text("PG-13")
    expect(page).to have_text((Time.now.year - 1).to_s)
    expect(page).to have_text("$123,456,789.00")
    expect(page).to have_text(@genre1.name)
    expect(page).to have_text(@genre2.name)
    expect(page).not_to have_text(@genre3.name)
    
    expect(page).to have_text("Movie was successfully created!")
  end

  it "does not create an invalid movie" do
    # Action
    visit movies_url
    click_link "Add New Movie"

    # Assert
    expect(current_path).to eq(new_movie_path)
    expect(find_field("Title").value).to eq(nil)

    # Action
    fill_in "Title", with: "New Movie Title"
    fill_in "Description", with: ""
    click_button "Create Movie"

    # Assert
    expect(current_path).to eq(movies_path)
    expect(find_field("Title").value).to eq("New Movie Title")
    expect(find_field("Description").value).to eq("")
  end

  # Course instructor's feature spec
  it "does not save the movie if it's invalid" do
    # Action
    visit new_movie_url

    # Assert
    expect {
        click_button "Create Movie"
    }.not_to change(Movie, :count)

    expect(current_path).to eq(movies_path)
    expect(page).to have_text("error")
  end
end