# This is the API we plan on using -- since we need to revert to long polling
require 'plex-ruby'

module Agents
  class PlexAgent < Agent
    default_schedule '3h' # You can schedule this more in the UI but this is a good default since most people do not need real time updates
                          # on this kind of thing

    # This agent can only send events to the pool, there is nothing it can recieve
    cannot_receive_events!

    description <<-MD
      This agent integates with Plex Media Server using the plex-ruby API and gives you notifications about various Plex Media fplex events going on so
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
      errors.add(:base, 'You must provide a valid server API key. You can generate one at https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/') unless options['api_key'].present?
      
      # There may be more but this is all I can think of right now
    end

    def working?
      received_event_without_error?
    end

    def check
      # Update the memory if the last check has been a while
      memory['last_check'] = memory['last_check'] || Time.now.to_i

      perform_check
      update_timestamp
    end

    def perform_check
      Plex.configure do |config|
        config.auth_token = options[:api_key] # The API key provided from the code
      end
  
      # The last updated timestamp in the memory cache and then use this as a basis point
      last_check = memory['last_check']
  
      # Query the service now
      server = Plex::Server.new(options[:hostname], options[:port])
      sections = server.library.sections
      
      sections = server.library.sections
      sections.each do |section|
        section.all.each do |entry|
          updated_at = Integer(entry.attribute_hash['updated_at'])
          if updated_at > last_check
            create_event_for entry
          end
        end
      end
    end

    def create_event_for(entry)
      create_event :payload => { 
        'title' => entry.attribute_hash['title'],
        'action' => 'updated',
        'type' => entry.attribute_hash['type']
      }    
    end

    def update_timestamp
      # The variable memory can be used in here to let you know when things are saved. 
      memory['last_check'] = Time.now.to_i
    end
  end
end
