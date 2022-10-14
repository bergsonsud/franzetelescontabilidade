class ObservationsController < ApplicationController
  before_action :set_observation, only: [:show, :edit, :update, :destroy]
  after_action :set_customers, only: [:create, :update]

  # GET /observations
  # GET /observations.json
  def index
    #@observations = Observation.all
    @search = Observation.all.ransack(params[:q])
    @observations = @search.result(distinct: true)
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
  end

  # GET /observations/new
  def new
    @observation = Observation.new
  end

  # GET /observations/1/edit
  def edit
  end

  # POST /observations
  # POST /observations.json
  def create2
    @observation = Observation.new(observation_params)

    respond_to do |format|
      if @observation.save
        format.html { redirect_to @observation, notice: 'Observation was successfully created.' }
        format.json { render :show, status: :created, location: @observation }
      else
        format.html { render :new }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @observation = Observation.new(observation_params)    
    respond_to do |format|
      if @observation.save            
        format.json { head :no_content }
        format.js        
      else        
        format.json { render json: @observation.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end  

  def set_customers    
    @observation.customer_ids = params[:customers].map(&:to_i)        
  end

  # PATCH/PUT /observations/1
  # PATCH/PUT /observations/1.json
  def update
    respond_to do |format|
      if @observation.update(observation_params)
        format.json { head :no_content }
        format.js
      else        
        format.json { render json: @observation.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /observations/1
  # DELETE /observations/1.json
  def destroy
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to observations_url, notice: 'Observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_observation
      @observation = Observation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def observation_params
      params.require(:observation).permit(:descricao, :content)
    end
end
