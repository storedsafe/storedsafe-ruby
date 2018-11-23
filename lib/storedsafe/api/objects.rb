# frozen_string_literal: true

module Storedsafe
  ##
  # Handles API requests to the /object path.
  class API
    # rubocop:disable Metrics/ParameterLists

    ##
    # Lists all information regarding an object and optionally decrypts
    # encrypted fields.
    def list_information(object_id, decrypt = false)
      res = request(
        :get, "/object/#{object_id}", token: @token, decrypt: decrypt
      )
      parse_body(res)
    end

    ##
    # Creates a new object in an existing vault.
    def create_object(
      template_id, group_id, parent_id, object_name, template_args
    )
      res = request(
        :post, '/object', {
          token: @token, templateid: template_id, groupid: group_id,
          parentid: parent_id, objectname: object_name
        }.merge(template_args)
      )
      parse_body(res)
    end

    ##
    # Edits an existing object.
    def edit_object(
      object_id, template_id, group_id, parent_id, object_name, template_args
    )
      res = request(
        :put, "/object/#{object_id}", {
          token: @token, templateid: template_id, groupid: group_id,
          parentid: parent_id, objectname: object_name
        }.merge(template_args)
      )
      parse_body(res)
    end

    ##
    # Deletes an existing object.
    def delete_object(object_id)
      res = request(:delete, "/object/#{object_id}", token: @token)
      parse_body(res)
    end

    ##
    # Search in unencrypted data to find an object.
    def find_object(needle)
      res = request(:get, '/find', token: @token, needle: needle)
      parse_body(res)
    end

    # rubocop:enable Metrics/ParameterLists
  end
end
