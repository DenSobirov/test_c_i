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

User.create(email: 'email3@email.com', name: 'name4 first5 last6', company: 'dc')
u_id = User.first.id

# 100.times.map { User.new() }

100.times do
  p = Post.create(title: Faker::Lorem.sentence, body: Faker::Lorem.sentences.join(' '), user_id: u_id)
  a = []
  2000.times do
    a << Comment.new(
      body: Faker::Lorem.sentence(word_count: 1000),
      post_id: p.id
    )
  end
  Comment.import a
  GC.start
end

User.delete_all && Comment.delete_all && Post.delete_all
