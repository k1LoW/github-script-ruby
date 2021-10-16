# frozen_string_literal: true

module GitHub
  module Actions
    module Toolkit
      class Logger
        def fatal(message)
          core.error(message)
          exit 1
        end

        def error(message)
          core.error(message)
        end

        def warn(message)
          core.warning(message)
        end

        def info(message)
          core.info(message)
        end

        def debug(message)
          core.debug(message)
        end

        private

        def core
          @core ||= GitHub::Actions::Toolkit::Core.new
        end
      end
    end
  end
end
