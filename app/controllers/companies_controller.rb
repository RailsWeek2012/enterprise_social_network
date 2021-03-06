class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.where('id > 0').order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
	  begin
		  if params[:id].to_i != 0
			  # id given
		    @company = Company.find(params[:id])
		  else
			  # name given
			  @company = Company.find_by_name(params[:id])
		  end
	  rescue Exception => e
		  @company = nil
		end

	  if @company.nil?
		  redirect_to root_path, alert: "This company does not exist."
		  return
	  end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
	  unless @company.owner == current_user
		  redirect_to companies_path
	  end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(params[:company])
    @company.create_default_infos

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company successfully created.' }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    @company.infos.each do |i|
	    i.value = params[i.key]
	    i.save
    end

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to @company, notice: 'Company successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end
end
