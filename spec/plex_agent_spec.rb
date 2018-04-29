require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::PlexAgent do
  before(:each) do
    @valid_options = Agents::PlexAgent.new.default_options
    @checker = Agents::PlexAgent.new(:name => "PlexAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
