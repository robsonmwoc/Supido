# Supido

** This gem is under intensive development, as soon as I can make it stable I
will warning you.**

Supido (pronouces speedo) is the Japanese word for Speed.

Supido is a profiling tool integrated to Apache Benchmark (ab) to help you
design usage cases and check the performance of your systems from different
perspectives.

Supido is designed to provide a way to build a stack of requests configurations,
and run these requests parallelly, helping you to simulate several different 
access behavior, with different puposes and concurrency levels.

## Installation

To use it, add this line to your application's Gemfile:

    gem 'supido'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install supido

## Usage

**This description is not good enough.** Soon I will provide a command line 
generator, and a easy way to execute your profiles using Supido.

It's very simple to use the Supido performance. A example case is to 
simulate a profile usage where a group of 100 requests, with concurrency of 5 
(100/5), is pointed to your front page, while another group of requests (100/2) 
are posting new comments to a specific post entry. So, your application will 
receive 200 requests with concurrency level at 7, and doing reading and writing
at same time. The description code would be like this:

    profile = Supido::Profile.new("VisitAndComment")
    profile.queue_actions("AccessingHomePage") do |action|
      action.url = "http://my_fancy.blog"
      action.concurrency = 5
      action.requests = 100
    end

    profile.queue_actions("WritingComments") do |action|
      action.url = "http://my_fancy.blog/comments"
      action.requests = 100
      action.concurrency = 2
      action.postdata = {
                          title: "My Comment", 
                          content: "Comment content", 
                          post_id: 1
                        }
    end

    profile.run!

## Actions Paramethers

  action.attachment = {
                        filename: "image.jpg",
                        content_type: "image/jpeg",
                        filepath: "/path/to/file"
                      }

## ROADMAP

There is a lot of work to do, and as soon as I can update the TODO list and fix
the open issues I will be updating this Roadmap.

What I want to achieve with the final release is integration with test tools,
such as TestUnit, MiniTest and Rspec. Until then, there is a lot of work to be 
done.

### Version 0.1

* Update the documentation
* Write rdocs
* Write the analytics inspector of ab reports

### Version 0.2

* Integration to R script (RSRuby)
* New profile external based on RSRuby
* Look at ActiveSupport and Monitor

### Version 0.3

* Integration with TestUnit
* Integration with Minitest

### Version 0.4

* Integration with Rspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
