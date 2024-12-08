class ResponsesController < ApplicationController
  
  def index
    @response = Response.all
  end  

  def show 
    @response = Response.find(params[:id])
  end
  
  def new 
    @response = Response.new
  end
  
  def create 
    @response = Response.new(response_params)
    if @response.save
      redirect_to @response, notice: 'Response was successfully created'  
    else
      render :new
    end
  end

  private 

  def response_params
    params.require(:response).permit(:ia_response, :status)
  end  

end  