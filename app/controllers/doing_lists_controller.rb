class DoingListsController < ApplicationController
  before_action :set_doing_list, only: [:show, :edit, :update, :destroy]

  # GET /doing_lists
  # GET /doing_lists.json
  def index
    @doing_lists = DoingList.all
  end

  # GET /doing_lists/1
  # GET /doing_lists/1.json
  def show
  end

  # GET /doing_lists/new
  def new
    @doing_list = DoingList.new
  end

  # GET /doing_lists/1/edit
  def edit
  end

  # POST /doing_lists
  # POST /doing_lists.json
  def create
    @doing_list = DoingList.new(doing_list_params)

    respond_to do |format|
      if @doing_list.save
        format.html { redirect_to @doing_list, notice: 'Doing list was successfully created.' }
        format.json { render :show, status: :created, location: @doing_list }
      else
        format.html { render :new }
        format.json { render json: @doing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doing_lists/1
  # PATCH/PUT /doing_lists/1.json
  def update
    respond_to do |format|
      if @doing_list.update(doing_list_params)
        format.html { redirect_to @doing_list, notice: 'Doing list was successfully updated.' }
        format.json { render :show, status: :ok, location: @doing_list }
      else
        format.html { render :edit }
        format.json { render json: @doing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doing_lists/1
  # DELETE /doing_lists/1.json
  def destroy
    @doing_list.destroy
    respond_to do |format|
      format.html { redirect_to doing_lists_url, notice: 'Doing list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doing_list
      @doing_list = DoingList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doing_list_params
      params.require(:doing_list).permit(:user_id, :tweet_id)
    end
end
