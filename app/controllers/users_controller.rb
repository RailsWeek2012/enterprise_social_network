require 'digest'

class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.where('company_id = ?', current_user.company_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
	  begin
      @user = current_user.company.users.find(params[:id])
	  rescue Exception => e
		  redirect_to root_path, alert: "This user does not exist."
			return
		end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def invite
	  render action: "invite"
  end

  def send_invite
	  check = Reservation.find_by_email(params[:email]) || User.find_by_email(params[:email])
	  @reservation = Reservation.new
	  @reservation.email = params[:email]
	  @reservation.company = current_user.company
	  @reservation.inviter = current_user
	  @reservation.token = Digest::SHA1.hexdigest(params[:email])[4..20]
	  if @reservation.save && check.nil?
		  UserMailer.invitation_mail(@reservation).deliver
		  redirect_to invite_user_path, notice: "Invitation sent."
	  else
		  if check.nil?
		    redirect_to invite_user_path
		  else
			  redirect_to invite_user_path, alert: "This user has already been invited."
			end
	  end
  end

  # GET /users/new
  # GET /users/new.json
  def new
	  @company = Company.new
    @user = User.new

	  unless params[:token].nil?
		  @reservation = Reservation.find_by_token(params[:token])
			if @reservation.nil?
				redirect_to users_path
				return
			else
		    @company = @reservation.company
		    @user.email = @reservation.email
			end
	  end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
	  unless current_user == @user
		  redirect_to users_path
	  end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    if params[:reservation].nil?
      @company = Company.new(params[:company])
    else
	    # user has been invited, company already exists
	    @company = Company.find(params[:company][:id])
	    @user.company = @company
	    Reservation.find_by_token(params[:reservation][:token]).delete
	  end

    respond_to do |format|
      if @user.save
	      if params[:reservation].nil?
		      # set company owner
	        @company.owner = @user
	        @company.save
	        @company.create_default_infos
	        @user.company = @company
	      end
	      @user.save
        format.html { redirect_to :users, notice: 'Registration successful.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Profile successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if @user.company.owner != @user
	    @user.groups.each do |g|
		    # destroy groups, where user is only member
		    if g.users.count == 1 && g.users.first == @user
			    g.posts.destroy_all
			    g.destroy
		    end
	    end
	    @user.posts.destroy_all
	    @user.destroy
    else
	    redirect_to root_path, alert: "You can't delete your account, while you're the owner of your company."
			return
    end

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Your account has been cancelled." }
      format.json { head :no_content }
    end
  end
end
