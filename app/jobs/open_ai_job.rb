class OpenAiJob < ApplicationJob
  queue_as :default

  def perform(form_id)
    form = Form.find(form_id)

    # Initialize the OpenAI service
    ai_service = OpenAiService.new

    # Generate the title
    title_result = ai_service.generate_title(description: form.description)
    Rails.logger.info "Generating Title result: #{title_result.inspect}"

    if title_result[:success]
      form.update!(name: title_result[:data].strip[0..49]) # Enforce 50 character limit
    else
      Rails.logger.warn "Title generation failed: #{title_result[:error]}"
      form.update!(name: "Untitled") # Fallback name
    end

    # Generate the response
    ai_result = ai_service.generate_response(description: form.description)
    Rails.logger.info "AI Result: #{ai_result.inspect}"

    if ai_result[:success]
      # Save the AI response to the database
      form.responses.create!(
        ia_response: ai_result[:data],
        status: "completed"
      )
    else
      Rails.logger.warn "Response generation failed: #{ai_result[:error]}"
    end
  rescue StandardError => e
    Rails.logger.error "OpenAiJob failed for Form ID #{form_id}: #{e.message}"
  end
end
