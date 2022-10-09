# for sharding multitenance

ActiveRecord::Base.connected_to(role: :writing, shard: :marvel) do
  User.create(email: 'email2@email.com', name: 'name first2 last2', company: 'marvel')
  15.times do
    p = Post.create(title: Faker::Lorem.sentence, body: Faker::Lorem.sentences.join(' '), user: User.first)
    20.times { Comment.create(body: Faker::Lorem.sentence, post: p) }
  end
end

ActiveRecord::Base.connected_to(role: :writing, shard: :dc) do
  User.create(email: 'email@email.com', name: 'name first last', company: 'dc')
  10.times do
    p = Post.create(title: Faker::Lorem.sentence, body: Faker::Lorem.sentences.join(' '), user: User.first)
    20.times { Comment.create(body: Faker::Lorem.sentence, post: p) }
  end
end

# for indexies and query optimization

# User.delete_all && Comment.delete_all && Post.delete_all

User.create(email: 'email3@email.com', name: 'name4 first5 last6', company: 'dc')
u_id = User.first.id

i = 0
300.times do
  p = Post.create(title: Faker::Lorem.sentence, body: Faker::Lorem.sentences.join(' '), user_id: u_id)
  a = []
  2000.times do
    a << Comment.new(
      body: Faker::Lorem.sentence(word_count: 1000),
      body_with_index: Faker::Lorem.sentences.join(' '),
      # body_with_index: Faker::Lorem.sentence(word_count: 1000),
      longitude_with_index: lons.sample,
      latitude_with_index: lats.sample,
      longitude: lons.sample,
      latitude: lats.sample,
      post_id: p.id
    )
  end
  Comment.import a
  p i += 1
end

lats = 1000.times.map { Faker::Address.latitude }
lons = 1000.times.map { Faker::Address.longitude }
i = 0
Comment.find_in_batches do |comments|
  a = comments.map do
    _1.longitude = lons.sample
    _1.latitude = lats.sample
    _1.longitude_with_index = lons.sample
    _1.latitude_with_index = lats.sample
    _1
  end
  Comment.import a, on_duplicate_key_update: { conflict_target: [:id], columns: [:longitude_with_index, :latitude_with_index] }
  p i += 1
end

# =============================================================
# pg_dump test_c_i_development > test_dump
# psql test_c_i_development < test_dump
# =============================================================

i = 0
Comment.find_in_batches do |comments|
  a = comments.map do
    _1.body_with_index = Faker::Lorem.sentences.join(' ')
    _1
  end
  Comment.import a, on_duplicate_key_update: { conflict_target: [:id], columns: [:body_with_index] }
  p i += 1
end

# gin index
# Comment.where("body_with_index ilike '%nemo%'")
# Comment.where("body ilike '%nemo%'")