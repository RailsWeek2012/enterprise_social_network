class PostsController < ApplicationController
	def like
		l = Like.create(user_id: current_user.id, post_id: params[:id])

		@post = Post.find(params[:id])

		respond_to do |format|
			format.js
		end
	end

	def unlike
		l = Like.where('user_id = ? AND post_id = ?', current_user.id, params[:id])
		l.destroy_all

		@post = Post.find(params[:id])

		respond_to do |format|
			format.html { redirect_to root_path }
			format.js
		end
	end

	def set_image_url
		@post = Post.find(params[:id])
		@post.update_attribute(:image_url, params[:image_url])

		respond_to do |format|
			format.json { head :no_content }
		end
	end

  # GET /posts
  # GET /posts.json
  def index
	  if user_signed_in?
		  if params[:group].nil?
			  @posts = PostsHelper.get_all_posts current_user.company_id
		  else
			  @group = Group.find(params[:group])
			  if current_user.groups.include? @group
			    @posts = Post.get_group_posts
			  else
				  redirect_to root_path
				  return
				end
			end

	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: @posts }
	    end
	  else
		  redirect_to root_path
		end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
	  if user_signed_in?
	    @post = Post.find(params[:id])

	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @post }
	    end
	  else
		  redirect_to root_path
		end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @post.parent_id = params[:parent_id]
    @post.company_id = current_user.company_id
    @post.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
	    format.js
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    if @post.contains_link? && @post.extract_images.length > 0
	    @post.image_url = @post.extract_images.first
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
	      format.js
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.user == current_user && @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.comments.destroy_all
    @post.destroy

    respond_to do |format|
      format.html { head :no_content }
      format.js
    end
  end

	def render_comment_form
		@post = Post.find(params[:id])
		begin
			@group = Group.find(params[:group])
		rescue Exception => e
		end
		render partial: "comment_form"
	end
end
