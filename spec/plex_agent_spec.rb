require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::PlexAgent do
  before(:each) do
    @valid_options = Agents::PlexAgent.new.default_options
    @checker = Agents::PlexAgent.new(:name => "PlexAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  # Sorry, no specs. :( I was going to add some but I'm not a native Ruby Developer and just learned enough
  # so I could create this gem for my own personal use. The code is pretty simple though, so should be good.
  pending "add specs here"
end
