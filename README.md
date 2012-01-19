# github-api-client

GitHub API Client that supports caching content client-side, allowing every later requests to be **instant**.

# Configuration
You have three ways of defining your user to have authenticated access to your API:
  
1. Put a file in: ~/.github/secrets.yml or \Users\username\.github\secrets.yml
        # secrets.yml
        user:
          login: your_login
          token: your_token
2. Put GITHUB_USER and GITHUB_TOKEN in your environment, so github-api-client can read it.
3. Configure your global git profile as defined here http://help.github.com/git-email-settings
  
## Contributing to github-api-client
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Jakub Okoński. See LICENSE.txt for
further details.

