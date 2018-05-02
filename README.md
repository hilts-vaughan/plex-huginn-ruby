# PlexAgent

This Ruby Gem for Huginnn will enable you to get events about your Plex library changing. This is valuable if you want to send Digest Emails, alert other people in your household to the new changes in your library or whatever else your imagination can figure out.

In my personal use case, I use this for notifying a couple people that things are now available and that we should watch them together. It also let's me know as an added bonus, since my life is busy and I don't have time to just check Plex for new content all the time.

## Installation

This gem is run as part of the [Huginn](https://github.com/huginn/huginn) project. If you haven't already, follow the [Getting Started](https://github.com/huginn/huginn#getting-started) instructions there.

Add this string to your Huginn's .env `ADDITIONAL_GEMS` configuration:

```ruby
# when only using this agent gem it should look like this, otherwise just append:
ADDITIONAL_GEMS=plex-ruby,huginn_plex_agent(github: hilts-vaughan/plex-huginn-ruby)
```

And then execute if you are running local, Docker should take care of this otherwise:

    $ bundle

## Usage

1. You will need a local Plex Media Server, which I assume you have if you landed up here. 
2. You will need a Plex Server API Key. You can get one [here](https://forums.plex.tv/discussion/129922/how-to-request-a-x-plex-token-token-for-your-app/p1) if you don't already have one -- you need it to configure the agent.
3. You will need to configure the Agent -- it just appears as a Plex Agent -- give your host, portname and API like so:

![plex](/assets/configure.png)


## Development

If you want to contribute, you should check out the base agent library: https://github.com/[my-github-username]/huginn_plex_agent/fork and then follow their guidance there. 

## Using the events

You get a payload that looks something like this:

![plex](/assets/event.png)

# Need something?

If I'm missing somem functionality, let me know. This is super basic now but it fit my use case, which was the important thing for me. If you have other needs (such as things other than updated, like, say, new...) then we can talk or you can submit a pull request!

I will add things as I need them. Thanks for looking.
