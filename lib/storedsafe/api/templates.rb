# frozen_string_literal: true

module Storedsafe
  ##
  # Handles API requests to the /template path.
  class API
    ##
    # Obtains a list with information about all available templates.
    def list_templates
      res = request(:get, '/template', token: @token)
      parse_body(res)
    end

    ##
    # Obtains information about the specified template.
    # @param [Integer] template_id
    # @see list_templates
    def retrieve_template(template_id)
      res = request(:get, "/template/#{template_id}", token: @token)
      parse_body(res)
    end
  end
end
