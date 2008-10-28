module ActiveRecord
  module Validations
    module ClassMethods
      @@validates_array_subset_of_message       = 'contains an invalid element.'

      # validates_array_subset_of(*attr_names) {{{
      #
      # Validates whether the value of the specified attribute is a subset of the +Array+ given to :in .
      # 
      # For example, a real estate search that:
      # * includes only houses and condos;
      # * in suburbia or the west-end.
      #
      #   class RealEstateSearch < ActiveRecord::Base
      #     # params[:styles] == %w(House Condo)
      #     validates_array_subset_of :styles, :in => %w(House Apartment Condo), :message => 'What kind of property are you looking for??'
      #
      #     # params[:neighbourhoods] == %w(Suburbia West-End)
      #     validates_array_subset_of :neighbourhoods, :in => %(Uptown Downtown Suburbia West-End East-End)
      #   end
      #
      # Configuration options:
      # * <tt>:in</tt> - An +Array+ of objects that is the superset.
      # * <tt>:message</tt> - Specifies a custom error message. Defaults to 'Invalid element(s) in the set.'
      # * <tt>:allow_blank</tt> - If set to true, skips this validation if the attribute is blank (default is +false+).
      # * <tt>:allow_nil</tt> - If set to true, skips this validation if the attribute is nil (default is +false+).
      # * <tt>:if</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   occur (e.g. <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>).  The
      #   method, proc or string should return or evaluate to a true or false value.
      # * <tt>:unless</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   not occur (e.g. <tt>:unless => :skip_validation</tt>, or <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>).  The
      #   method, proc or string should return or evaluate to a true or false value.
      # 
      def validates_array_subset_of(*attr_names)
        configuration = {:message => @@validates_array_subset_of_message}
        configuration.update attr_names.extract_options!

        raise ArgumentError, 'An Array must be supplied for the :in option of the configuration hash' unless configuration[:in].is_a? Array
        superset = configuration[:in]

        validates_each attr_names, configuration do |record, attr_name, value|
          record.errors.add attr_name, configuration[:message] unless value.is_a? Array and (value - superset).empty?
        end
      end # }}}
    end
  end
end
