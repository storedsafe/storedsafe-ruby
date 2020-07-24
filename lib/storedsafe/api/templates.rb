# frozen_string_literal: true

module StoredSafe
  ##
  # Handles API requests to the /template path.
  class API
    ##
    # Obtains a list with information about all available templates.
    def list_templates
      request_get('/template')
    end

    ##
    # Obtains information about the specified template.
    # @param [Integer] template_id
    def get_template(template_id)
      request_get("/template/#{template_id}")
    end
  end
end
