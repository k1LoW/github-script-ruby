# frozen_string_literal: true

require 'json'
require 'ostruct'
require 'octokit'

Octokit.configure do |c|
  c.api_endpoint = ENV['GITHUB_API_URL'] || 'https://api.github.com'
  c.auto_paginate = true
end

module GitHub
  module Actions
    module Toolkit
      class Runner
        def run
          output = main
          output = JSON.generate(output) unless core.get_input('result_encoding') == 'string'
          core.set_output('result', output)
        end

        def github
          @github ||= Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
        end

        def context
          return @context unless @context.nil?

          @context = OpenStruct.new
          @context.payload = JSON::Parser.new(File.read(ENV['GITHUB_EVENT_PATH']), object_class: OpenStruct).parse if ENV['GITHUB_EVENT_PATH']
          @context.event_name = ENV['GITHUB_EVENT_NAME'] || ''
          @context.sha = ENV['GITHUB_SHA'] || ''
          @context.ref = ENV['GITHUB_REF'] || ''
          @context.workflow = ENV['GITHUB_WORKFLOW'] || ''
          @context.action = ENV['GITHUB_ACTION'] || ''
          @context.actor = ENV['GITHUB_ACTOR'] || ''
          @context.job = ENV['GITHUB_JOB'] || ''
          @context.run_number = ENV['GITHUB_RUN_NUMBER'] ? ENV['GITHUB_RUN_NUMBER'].to_i : nil
          @context.run_id = ENV['GITHUB_RUN_ID'] ? ENV['GITHUB_RUN_ID'].to_i : nil
          @context.api_url = ENV['GITHUB_API_URL'] || 'https://api.github.com'
          @context.server_url = ENV['GITHUB_SERVER_URL'] || 'https://github.com'
          @context.graphql_url = ENV['GITHUB_GRAPHQL_URL'] || 'https://api.github.com/graphql'

          # repo
          if ENV['GITHUB_REPOSITORY']
            owner, repo = ENV['GITHUB_REPOSITORY'].split('/')
            @context.repo = OpenStruct.new({ owner: owner, repo: repo })
          elsif payload&.repository
            @context.repo = OpenStruct.new({ owner: payload.repository.owner.login, repo: payload.repository.name })
          end

          # issue
          if @context.payload
            number = @context.payload&.issue&.number || @context.payload&.pull_request&.number || @context.payload&.number
            if number
              @context.issue = OpenStruct.new
              @context.issue.number = number
              if @context.repo
                @context.issue.owner = @context.repo.owner
                @context.issue.repo = @context.repo.repo
              end
            end
          end

          @context
        end

        def core
          @core ||= GitHub::Actions::Toolkit::Core.new
        end

        def main; end
      end
    end
  end
end
