class EvaluatePromptJob < ApplicationJob
  queue_as :default

  def perform(form_id)
    form = Form.find(form_id)

    # Call OpenAI or custom logic to evaluate the qualification
    ai_service = OpenAiService.new
    evaluation_result = ai_service.evaluate_prompt(description: form.description)

    if evaluation_result[:success]
      form.update!(qualification: evaluation_result[:data]) # Assuming `qualification` is a field in Form
      Rails.logger.info "Prompt qualification updated for Form ID #{form_id}: #{evaluation_result[:data]}"
    else
      Rails.logger.warn "Failed to evaluate prompt for Form ID   #{form_id}: #{evaluation_result[:error]}"
    end
  rescue StandardError => e
    Rails.logger.error "EvaluatePromptJob failed for Form ID #{form_id}: #{e.message}"
  end
end
