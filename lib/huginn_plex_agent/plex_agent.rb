# This is the API we plan on using -- since we need to revert to long polling
require 'plex-ruby'

module Agents
  class PlexAgent < Agent
    default_schedule '3h' # You can schedule this more in the UI but this is a good default since most people do not need real time updates
                          # on this kind of thing

    # This agent can only send events to the pool, there is nothing it can recieve
    cannot_receive_events!

    description <<-MD
      This agent integates with Plex Media Server using the plex-ruby API and gives you notifications about various Plex Media Server events going on so
      that you can generate events from them.

      To start with, the only supported events are the events for media being added but more will be added over time.
    MD

    def default_options
      {
        hostname: 'hostname',
        port: 32400,
        api_key: 'You must insert an API key'
      }
    end

    def validate_options
      errors.add(:base, 'You must provide a valid server address to poll for the updates') unless options['hostname'].present?
      errors.add(:base, 'You must provide a valid server port to poll for the updates.') unless options['port'].present?
      errors.add(:base, 'You must provide a valid server API key. You can generate one at https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/') unless options['server_address'].present?
      
      # There may be more but this is all I can think of right now
    end

    def working?
      received_event_without_error?
    end

    def check
      memory['last_check'] ||= Time.now.getutc

      perform_check
      update_timestamp
    end

    def perform_check
      Plex.configure do |config|
        config.auth_token = options['api_key'] # The API key provided from the code
      end

      # The last updated timestamp in the memory cache
      last_check = memory['last_check']

      # Query the service now
      server = Plex::Server.new(options['hostname'], CONFIG[options['port']])
      sections = server.library.sections
      
      sections = server.library.sections
      sections.each do |section|
        section.select do |entry|
          if entry.updatedAt > last_check
            create_event_for entry
          end
        end
      end
    end

    def create_event_for(entry)
      create_event :payload => { 
        'title' => entry.title,
        'action' => 'updated',
        'type' => entry.type
      }    
    end

    def update_timestamp
      # The variable memory can be used in here to let you know when things are saved. 
      memory['last_check'] = Time.now.getutc
    end
  end
end
