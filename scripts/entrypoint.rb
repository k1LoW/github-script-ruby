# frozen_string_literal: true

require 'erb'
require 'json'
require 'tempfile'
require 'open3'
require_relative '../lib/github/actions/toolkit'

core = GitHub::Actions::Toolkit::Core.new
script = core.get_input('script')
gemfile_path = if core.get_input('gemfile').empty?
                 '/github-script-ruby/Gemfile'
               else
                 '/tmp/Gemfile'
               end

status = 1
src = ERB.new(DATA.read).result(binding)
Tempfile.create do |f|
  f.write(src)
  f.close
  o, e, s = Open3.capture3(ENV.to_hash, "bundle exec --gemfile=#{gemfile_path} ruby #{f.path}")
  core.error(e) unless e == ''
  status = s.to_i
  print o
end

exit 1 unless status.zero?
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
