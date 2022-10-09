module Optimization
  extend self

  # query opt, use in console

  # ======================================================================

  # Use queries to relations with includes
  # The advantage is the will be just two queries

  def unoptimized_includes_query
    Post.limit(5).each { |p| p.comments.each(&:id) }
  end

  def optimized_includes_query
    Post.limit(5).includes(:comments).each { |p| p.comments.each(&:id) }
  end

  # ======================================================================

  # Use #find_each instead of #each when calling all objects

  def unoptimized_all_query
    Comment.all
           #  .limit(1000)
           .each { _1.touch }
  end

  def optimized_all_query
    # Comment.find_in_batches
    Comment.all
           #  .limit(1000)
           .find_each(batch_size: 100) do |comment|
             comment.touch
           end
  end

  # ======================================================================

  # Use #select and #pluck instead of using all object columns
  # reducing memory use

  def incorrect_columns_call
    Post.limit(20).map(&:title)
  end

  def correct_columns_call1
    # return Array
    Post.limit(20).pluck(:title)
  end

  def correct_columns_call2
    # return ActiveRecord_Relation object
    Post.limit(20).select(:title)
  end

  def correct_objects_call
    # return all the attributes of a model if ypu need
    Post.limit(20)
  end

  # ======================================================================

  # Check existence of record with #exists? instead of #present?
  # The advantage is the corresponding query limits only to 1 record and does not select any columns.

  def incorrect_check_existence
    Comment.where(post_id: Post.forty_two&.id).present?
  end

  def correct_check_existence
    Comment.where(post_id: Post.forty_two&.id).exists?
  end

  # ======================================================================

  # Use #size insted of #count ActiveRecord::Relation objects
  # #size is smarter in that it will call length on the relation if it already has been loaded
  # #count will always run the query
  # File activerecord/lib/active_record/relation.rb, line 210
  # def size
  #   loaded? ? @records.length : count(:all)
  # end

  def incorrect_count
    Comment.where(post_id: Post.forty_two&.id).count
  end

  def correct_count
    Comment.where(post_id: Post.forty_two&.id).size
  end

  # ======================================================================

  # Use #delete_all with bulk delete

  def incorrect_bulk_delete
    # Comment.find_each do |c|
    #   c.destroy
    # end

    # ====
    # OR
    # ====

    # Comment.destroy_all
    puts 'see in source file'
  end

  def correct_bulk_delete
    # Comment.delete_all
    puts 'see in source file'
  end

  # ======================================================================

  # Use bulk create

  def incorrect_create
    user_id = User.first&.id
    new_posts_array = [
      { user_id: user_id, title: 'title1', body: 'body1' },
      { user_id: user_id, title: 'title2', body: 'body2' },
      { user_id: user_id, title: 'title3', body: 'body3' },
      { user_id: user_id, title: 'title4', body: 'body4' },
    ]
    new_posts_array.each do |post_hash|
      Post.create(post_hash)
    end
  end

  def correct_create
    user_id = User.first&.id
    new_posts_array = [
      { user_id: user_id, title: 'title1', body: 'body1' },
      { user_id: user_id, title: 'title2', body: 'body2' },
      { user_id: user_id, title: 'title3', body: 'body3' },
      { user_id: user_id, title: 'title4', body: 'body4' },
    ]
    # All the records in one query if the database supports this feature.
    Post.create(new_posts_array)
    # Or you can use 'activerecord-import' gem
  end

  # ======================================================================

  # Use bulk update

  def incorrect_update
    Post.limit(10).each do |post|
      post.update(published: true)
    end
  end

  def correct_update
    # All the records in one query if the database supports this feature.
    Post.update_all(published: true)
    # Or you can use 'activerecord-import' gem
  end

  # ======================================================================

  # Use in-memory operations if needed instead of querying

  def incorrect_querying
    emails = %w[
      email1@email.com
      email2@email.com
      email3@email.com
    ]
    emails.map { |email| email unless User.where(email: email).exists? }.compact
  end

  def correct_inmemory_operations
    emails = %w[
      email1@email.com
      email2@email.com
      email3@email.com
    ]
    existing_emails = Set.new(User.pluck(:email))

    emails.map { |email| email if existing_emails.exclude?(email) }.compact
  end
  # ======================================================================

  # Use gem 'bullet'
  # Use 'benchmark'
  # Use db indices

  # ======================================================================
end
