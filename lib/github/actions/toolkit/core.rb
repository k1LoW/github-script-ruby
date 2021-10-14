# frozen_string_literal: true

module GitHub
  module Actions
    module Toolkit
      class Core
        def get_input(name)
          ENV["INPUT_#{name.gsub(/ /, '_').upcase}"] || ''
        end

        def set_output(name, value)
          puts make_output(name, value)
        end

        def error(message)
          puts "::error ::#{escape_data(message)}"
        end

        def make_output(name, value)
          "::set-output name=#{escape_property(name)}::#{escape_data(value)}"
        end

        private

        def escape_property(prop)
          prop&.gsub(/%/, '%25')&.gsub(/\r/, '%0D')&.gsub(/\n/, '%0A')&.gsub(/:/, '%3A')&.gsub(/,/, '%2C') || ''
        end

        def escape_data(data)
          data&.gsub(/%/, '%25')&.gsub(/\r/, '%0D')&.gsub(/\n/, '%0A') || ''
        end
      end
    end
  end
end
