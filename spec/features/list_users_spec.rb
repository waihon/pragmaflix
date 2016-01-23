describe "Viewing the list of users" do
  it "shows the users" do
    user1 = User.create!(user_attributes(name: "Larry Kent", email: "larry@example.com", username: "larryk"))
    user2 = User.create!(user_attributes(name: "Moe Joss",   email: "moe@example.com", username: "moej"))
    user3 = User.create!(user_attributes(name: "Curly Hay",  email: "curly@example.com", username: "curlyh"))

    visit users_url

    expect(page).to have_link(user1.name)
    expect(page).to have_link(user2.name)
    expect(page).to have_link(user3.name)
  end
end