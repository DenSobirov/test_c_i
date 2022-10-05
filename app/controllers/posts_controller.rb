class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    ActiveRecord::Base.connected_to(role: :reading, shard: request.subdomain.to_sym) do
      @posts = Post.all.to_a
      p 'this is query cache'
      @posts = Post.all.to_a
      very_expensive_calculation
      @post_for_touch = Post.ids.min
      # @very_expensive_calculation
    end
  end

  def touch_first
    ActiveRecord::Base.connected_to(role: :writing, shard: request.subdomain.to_sym) do
      Post.touch_first
    end
    redirect_to posts_path
  end

  # GET /posts/1 or /posts/1.json
  def show
    ActiveRecord::Base.connected_to(role: :reading, shard: request.subdomain.to_sym) do
      @comment = @post.comments.build
    end
  end

  # GET /posts/new
  def new
    ActiveRecord::Base.connected_to(role: :reading, shard: request.subdomain.to_sym) do
      @post = Post.new
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def very_expensive_calculation
    ActiveRecord::Base.connected_to(role: :reading, shard: request.subdomain.to_sym) do
      @very_expensive_calculation = Post.very_expensive_method
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    ActiveRecord::Base.connected_to(role: :reading, shard: request.subdomain.to_sym) do
      @post = Post.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
