# frozen_string_literal: true

module Storedsafe
  ##
  # Configures API requests to the /vault path.
  module Vaults
    class << self
      def list(); end

      def list_objects(); end

      def create(); end

      def edit(); end

      def delete(); end
    end
  end
end
