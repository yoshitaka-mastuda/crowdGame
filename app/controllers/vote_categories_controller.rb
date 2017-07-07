class VoteCategoriesController < ApplicationController
  before_action :set_vote_category, only: [:show, :edit, :update, :destroy]

  # GET /vote_categories
  # GET /vote_categories.json
  def index
    @vote_categories = VoteCategory.all
  end

  # GET /vote_categories/1
  # GET /vote_categories/1.json
  def show
  end

  # GET /vote_categories/new
  def new
    @vote_category = VoteCategory.new
  end

  # GET /vote_categories/1/edit
  def edit
  end

  # POST /vote_categories
  # POST /vote_categories.json
  def create
    @vote_category = VoteCategory.new(vote_category_params)

    respond_to do |format|
      if @vote_category.save
        format.html { redirect_to @vote_category, notice: 'Vote category was successfully created.' }
        format.json { render :show, status: :created, location: @vote_category }
      else
        format.html { render :new }
        format.json { render json: @vote_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vote_categories/1
  # PATCH/PUT /vote_categories/1.json
  def update
    respond_to do |format|
      if @vote_category.update(vote_category_params)
        format.html { redirect_to @vote_category, notice: 'Vote category was successfully updated.' }
        format.json { render :show, status: :ok, location: @vote_category }
      else
        format.html { render :edit }
        format.json { render json: @vote_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vote_categories/1
  # DELETE /vote_categories/1.json
  def destroy
    @vote_category.destroy
    respond_to do |format|
      format.html { redirect_to vote_categories_url, notice: 'Vote category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote_category
      @vote_category = VoteCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_category_params
      params.require(:vote_category).permit(:vote_id, :category_id)
    end
end
