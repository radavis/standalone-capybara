# standalone-capybara

Write capybara specs for any web app, local or remote.


## Instructions

```
brew install phantomjs
git clone git@github.com:radavis/standalone-capybara.git <YOUR_TEST_SUITE_NAME>
cd <YOUR_TEST_SUITE_NAME>
bundle
cp .env.example .env
# write feature specs
rake spec
```
