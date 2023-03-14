# frozen_string_literal: true

module GitHub
  module Actions
    module Toolkit
      class Core
        def get_input(name)
          ENV["INPUT_#{name.gsub(/ /, '_').upcase}"] || ENV["INPUT_#{name.gsub(/[\s-]/, '_').upcase}"] || ''
        end

        def set_output(name, value)
          wputs "#{escape_property(name)}=#{escape_data(value)}"
        end

        def debug(message)
          puts make_output('debug', message)
        end

        def error(message)
          puts make_output('error', message)
        end

        def warning(message)
          puts make_output('warning', message)
        end

        def notice(message)
          puts make_output('notice', message)
        end

        def info(message)
          puts message
        end

        def make_output(command, value)
          "::#{command} ::#{escape_data(value)}"
        end

        private

        def wputs(value)
          if ENV['GITHUB_OUTPUT'].nil?
            puts value
            return
          end
          File.open(ENV['GITHUB_OUTPUT'], 'a') do |f|
            f.puts value
          end
        end

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
