class AppsController < ApplicationController

  # GET /apps
  def index
    @apps = App.all
  end

  # GET /apps/new
  def new
    @app = App.new
  end

  # POST /apps
  def create
    @app = App.new(app_params)

    if @app.save
      #add find and replacing, file moving here?
      redirect_to action: 'index', notice: 'App was successfully created.'
    else
      render action: 'new', alert: 'App could not be created' 
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:properName, :downcase, :video, :poster)
    end
end
