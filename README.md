# Storedsafe API ruby wrapper

This is a ruby wrapper for the Storedsafe REST-like API.

# TODO

## High Priority
- [x] Expand defaults to rc file
- [ ] Add request method to API
- [x] ~~Write tests with environment control (which class should they belong to?)~~ Added environment control tests to Defaults module.

## Medium Priority
- [x] ~~Collect configuration options for rspec in support file~~ Changed how Defaults module works so only Configurable needs this information now, skipping support file.
- [ ] Look into persistent HTTP connection
