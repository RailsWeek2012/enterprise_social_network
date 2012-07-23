class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.json
  def index
	  if user_signed_in?
	    @groups = current_user.groups

	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: @groups }
	    end
		end
  end

  def invite
	  if user_signed_in?
		  @group = Group.find(params[:group])
		  @user = User.find(params[:user])

		  respond_to do |format|
			  if @group.users.push @user
				  format.json { render json: { success: true, group: @group, user: @user, inviter: current_user } }
			  else
				  format.json { render json: { success: false, group: @group, user: @user, inviter: current_user } }
				end
		  end
	  end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
	  begin
      @group = Group.find(params[:id])
	  rescue Exception => e
		  redirect_to root_path, alert: "This group does not exist."
		  return
		end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new
    @group.leader = current_user
    @group.users.push current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    @group.leader = current_user
    @group.users.push current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
end
