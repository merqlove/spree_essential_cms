module Spree
  module Admin
    module PageHelper
      def page_or_parent
        return @parent if @parent&.id.present?
        @page
      end
    end
  end
end