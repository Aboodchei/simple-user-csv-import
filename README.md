# User Importer 🤖
This was a fun project, I enjoyed it! It took me ~6 hours to complete.

## What's the idea here? 💡
The main idea behind the backend design is to be as simple as possible - a single controller, with a basic index action only rendering a form, and a turbo-stream-powered import action that handles user CSV uploads using ViewComponents.

##### Setup
- `$ rvm use 3.2.2` (or any similar ruby version management tool)
- `$ bundle install` to install Ruby dependencies.
- `$ rails db:setup` to setup the database.
- `$ rspec -f d` to run the tests (covering all core code, with different cases!)
- `$ rubocop` to run Rubocop.

#### Decisions / Areas of improvement

- I decided to use bcrypt and store the password digest. When a user uploads a CSV, the password data is only visible afterwards, but then they will not see it again.
- No background processing, although of course there might be a fear of timeout for larger CSV uploads, but for the sake of finishing this MVP as quickly as possible I decided otherwise. One idea I had was to implement functionality that detects whether an upload requires background processing or not, based on the number of rows (if > 500 for example we could process it in the background using sidekiq)
- Non-persistent file uploads. I decided not to save the CSV file using active storage, although that could have been neat and could have been used to further track the progress of a CSV upload, and would allow us to process larger CSVs in the background.
- Add error handling to non-csv related errors (perhaps handle different file types being uploaded, or any other possible errors). Would be nice to add an `ImportStatus::GENERIC` error type.

#### Thank you for your time. Hope you like it!
