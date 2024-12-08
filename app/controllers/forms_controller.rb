class FormsController < ApplicationController

  def index
    @forms = Form.includes(:responses).order(created_at: :desc)
    @form = Form.new
  end  

  def show 
    @form = Form.find(params[:id])
  end
  
  def new 
    @form = Form.new
  end
  
  def create 
    @form = Form.new(form_params)
    
    
    # Call the service
    ai_service = OpenAiService.new
    title_result = ai_service.generate_title(description: @form.description)
    Rails.logger.info "Generating Title result: #{title_result.inspect}"

    if title_result[:success]
      @form.name = title_result[:data].strip
      # @form.update(name: title_result[:data].strip)
    else
      Rails.logger.warn "Title generation failed: #{title_result[:error]}"
      @form.name = "Untitled" # Provide a fallback name if title generation fails
    end 
    
    if @form.save
      
      ai_result = ai_service.generate_response(description: @form.description)
      Rails.logger.info "AU Result #{ai_result.inspect}"

      if ai_result[:success]

        # Save the response into the DB
        @form.responses.create(
          ia_response: ai_result[:data],
          status: "completed"
        )
    
        redirect_to @form, notice: 'Form was successfully created'  
      else
        redirect_to @form, notice: "Form saved, but OpenAI failed: #{ai_result[:error]}"  
      end
    else
      Rails.logger.warn "Form save failed: #{@form.errors.full_messages}"
      render :index, status: :unprocessable_entity
    end    
  end

  private 

  def form_params
    params.require(:form).permit(:description)
  end    

end  