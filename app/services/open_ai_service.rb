class OpenAiService
    def generate_title(description:)
      retries ||=0
      uri = URI("#{ENV["URL"]}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https' # Habilita SSL si es HTTPS
      ask = {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: description },  # Aquí el mensaje del usuario
          { role: "assistant", content: "Its a mandatory that the summarize be 5 words lenght or less" }
        ],
        temperature: 0.7,
        max_tokens: 20
      }
  
  
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = ask.to_json
  
      response = http.request(request)
      response_body = JSON.parse(response.body)

      if response.code.to_i.between?(200, 299)
        { success: true, data: response_body["choices"].first["message"]["content"]}
      else
        { success: false, error: response_body["error"] || "Unknown error" }
      end
    rescue StandardError => e
      if (retries += 1) <= 3
        retry
      else
        { success: false, error: "Error after 3 retries: #{e.message}" }
      end
    end

    def generate_response(description:)
      retries ||=0
      uri = URI(ENV["URL"])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      ask = {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: description }
        ],
        temperature: 0.7,
        max_tokens: 150
      }

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = ask.to_json
  
      response = http.request(request)
      response_body = JSON.parse(response.body)

      if response.code.to_i.between?(200, 299)
        { success: true, data: response_body["choices"].first["message"]["content"]}
      else
        { success: false, error: response_body["error"] || "Unknown error" }
      end
    rescue StandardError => e
      if (retries += 1) <= 3
        retry
      else
        { success: false, error: "Error after 3 retries: #{e.message}" }
      end
    end

    def evaluate_prompt(description:)
      retries ||= 0
      uri = URI(ENV["URL"])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      ask = {
        model: "gpt-4",
        messages: [
          { role: "system", content: "You are a helpful assistant that evaluates prompt ty." },
          { role: "user", content: description },
          { role: "assistant", content: "Rate the prompt on a scale from 1 to 10, with 10 being excellent and 1 being poor. Provice a short explanation of your score." }
        ],
        temperature: 0.7,
        max_tokens: 50
      }


      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = ask.to_json

      response = http.request(request)
      response_body = JSON.parse(response.body)

      if response.code.to_i.between?(200, 299)
        { success: true, data: response_body["choices"].first["message"]["content"] }
      else
        { success: false, error: response_body["error"] || "Unknown error" }
      end
    rescue StandardError => e
      if (retries += 1) <= 3
        retry
      else
        { success: false, error: "Error after 3 retries: #{e.message}" }
      end
    end


  
    private
  
    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ENV["OPENAI_ACCESS_TOKEN"]}"
      }
    end
  
end

  # | Example | 
  # def analyze_sentiment(comment)
  #   prompt = "Analiza el sentimiento de este comentario: '#{comment}'. Responde con solo un número: 1 para feliz, 2 para enojado, 3 para triste."
  #   response = @client.chat(
  #   parameters: {
  #       model: "gpt-4",
  #       messages: [
  #       { role: "system", content: "Eres un asistente que analiza sentimientos y responde solo con un número del 1 al 3." },
  #       { role: "user", content: prompt }
  #       ],
  #       max_tokens: 10
  #   }
  #   )

  #   sentiment = response.dig("choices", 0, "message", "content").strip.to_i
  #   sentiment.between?(1, 3) ? sentiment : 0
  # end

