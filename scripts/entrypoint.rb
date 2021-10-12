# frozen_string_literal: true

require 'erb'
require 'json'
require 'tempfile'
require 'open3'
require "#{__dir__}/../lib/github/actions/toolkit"

core = GitHub::Actions::Toolkit::Core.new
script = core.get_input('script')
token = core.get_input('github-token')
status = 1
output = ''
src = ERB.new(DATA.read).result(binding)
Tempfile.create do |f|
  f.write(src)
  f.close
  File.read(f.path)
  o, e, s = Open3.capture3(ENV.to_hash, "bundle exec --gemfile=/github-script-ruby/Gemfile ruby #{f.path}")
  core.error(e) unless e == ''
  status = s.to_i
  print o
end

exit status
__END__
# frozen_string_literal: true

require '/github-script-ruby/lib/github/actions/toolkit'

module GitHub
  module Actions
    module Toolkit
      class Runner
        def main
          <%= script %>
        end
      end
    end
  end
end

GitHub::Actions::Toolkit::Runner.new.run
