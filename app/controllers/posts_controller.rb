class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
	  if user_signed_in?
		  if params[:group].nil?
			  @posts = PostsHelper.get_all_posts current_user.company_id
		  else
			  @group = Group.find(params[:group])
			  if current_user.groups.include? @group
			    @posts = Post.where('company_id = ? AND group_id = ?', current_user.company_id, params[:group]).order('created_at DESC')
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

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
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
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
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
    @comments = Post.where('parent_id = ?', @post.id)
    @comments.destroy_all
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
