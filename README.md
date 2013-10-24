# [DevDocs](http://devdocs.io) — Documentation Browser

DevDocs combines multiple API documentations in a fast, organized, and searchable interface.

* Created by [Thibaut Courouble](http://thibaut.me)
* Sponsored by [MaxCDN](http://www.maxcdn.com)

Keep track of development and community news:

* Subscribe to the [newsletter](http://eepurl.com/HnLUz)
* Follow [@DevDocs](https://twitter.com/DevDocs) on Twitter
* Join the [mailing list](https://groups.google.com/d/forum/devdocs)

DevDocs is free and open source. If you use it and like it, please consider donating through [Gittip](https://www.gittip.com/Thibaut/) or [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4PTFAGT7K6QVG). Your support helps sustain the project and is highly appreciated.

**Table of Contents:** [Quick Start](#quick-start) · [Vision](#vision) · [App](#app) · [Scraper](#scraper) · [Commands](#available-commands) · [Contributing](#contributing) · [License](#copyright--license) · [Questions?](#questions)

**Note:** I'm in the process of writing more documentation. As DevDocs is quite big, it'll take time. Feel free to [contact me directly](mailto:thibaut@devdocs.io) in the meantime.

## Quick Start

Unless you wish to use DevDocs offline or contribute to the code, I recommend using the hosted version at [devdocs.io](http://devdocs.io). It's up-to-date and requires no setup.

DevDocs is made of two separate pieces of software: a Ruby scraper responsible for generating the documentation files and indexes, and a JavaScript front-end powered by on small Sinatra app.

DevDocs requires Ruby 2.0. Once you have it installed, run the following commands:

```
gem install bundler
bundle install
thor docs:download --all
rackup
```
 
Finally, point your browser at [localhost:9292](http://localhost:9292) (the first request will take a few seconds to compile the assets). You're all set.

The `thor docs:download` command is used to download/update individual documentations (e.g. `thor docs:download html css`), or all at the same time (using the `--all` option). You can see the list of available documentations by running `thor docs:list`.

**Note:** there is currently no update mechanism other than using git to update the code and `thor docs:download` to download the latest version of the docs. To stay informed about new versions, be sure to subscribe to the [newsletter](http://eepurl.com/HnLUz).

## Vision

DevDocs aims to make reading and searching reference documentation fast, accessible and enjoyable, while aspiring to become the “one stop shop” for all open-source software documentations.

The app's main goals are to: keep boot and page load times as fast as possible; improve the quality, speed, and order of search results; maximize the use of caching and other performance optimizations; maintain a clean, readable user interface; support full keyboard navigation; reduce “context switch” by using a consistent typography and design across all documentations; reduce clutter by focusing on a specific category of content (API/reference) and indexing only the minimum useful to most developers.

**Note:** DevDocs is neither a programming guide nor a search engine. All content is pulled from third-party sources and the project does not intend to compete with full-text search engines. Its backbone is metadata: each piece of content must be identified by a unique, obvious and short string. Thus, tutorials, guides and other content that don't fit this requirement are outside the scope of the project.

## App

The web app is all JavaScript, written in [CoffeeScript](http://coffeescript.org), and powered by a small [Sinatra](http://www.sinatrarb.com)/[Sprockets](https://github.com/sstephenson/sprockets) application. It relies on files generated by the [scraper](#scraper).

Many of the code's design decisions were driven by the fact that the app uses XHR to load content directly into the main frame. This includes stripping the original documents of most of their HTML markup (e.g. scripts and stylesheets) to avoid polluting the main frame, and prefixing all CSS class names with an underscore to prevent conflicts.

Another driving factor is the requirement for speed. This is partially solved by maximizing caching (both `applicationCache`, which comes with its own set of constraints, and `localStorage` are used to their full extent), as well as by allowing the user to pick his/her own set of documentations. On the other hand, the search algorithm is currently not very sophisticated because it needs to be fast even searching through 100k entries.

DevDocs being a developer tool, the browser requirements are high:

1. On the desktop:
  * Recent version of Chrome
  * Recent version of Firefox
  * Safari 5.1+
  * Opera 12.1+
  * Interner Explorer 10+
2. On mobile:
  * iOS 6+
  * Android 4.1+
  * Windows Phone 8+

This allows the code to take advantage of the latest DOM and HTML5 APIs and make developing DevDocs a lot more fun!

## Scraper

The scraper is responsible for generating the documentation and index files (metadata) used by the [app](#app). It's written in Ruby under the `Docs` module.

There are currently two kinds of scrapers: `UrlScraper` which downloads files via HTTP and `FileScraper` which reads them from the local filesystem. They both make copies of HTML documents, recursively following links that match a given set of rules and applying all sorts of modifications along the way, in addition to building an index of the files and their metadata. Documents are parsed using [Nokogiri](http://nokogiri.org).

Modifications made to each document include:
* removing stuff, such as the document structure (`<html>`, `<head>`, etc.), comments, empty nodes, etc.
* fixing links (e.g. to remove duplicates)
* replacing all external (not copied) URLs with their fully qualified counterpart
* replacing all internal (copied) URLs with their unqualified and relative counterpart
* adding stuff, such as a title and link to the original document

These modifications are applied through a set of filters, with each scraper also applying custom filters specific to the documentation. Each document is also passed through a filter whose task is to figure out its metadata, namely its _name_ and _type_ (category).

The end result is a set of normalized HTML partials and a JSON index file. Because the index files are loaded separately by the [app](#app) following the user's preferences, the code also creates a JSON manifest file containing information about the documentations currently available on the system (such as their name, version, update date, etc.).

## Available Commands

The command-line interface uses [Thor](http://whatisthor.com). To see all commands and options, run `thor list` from the project's root.

```
# Server
rackup              # Start the server (ctrl+c to stop)
rackup --help       # List server options

# Docs
thor docs:list      # List available documentations
thor docs:download  # Download one or more documentations
thor docs:manifest  # Create the manifest file used by the app
thor docs:generate  # Generate/scrape a documentation
thor docs:page      # Generate/scrape a documentation page
thor docs:package   # Package a documentation for use with docs:download

# Console
thor console        # Start a REPL
thor console:docs   # Start a REPL in the "Docs" module
Note: tests can be run quickly from within the console using the "test" command. Run "help test"
for usage instructions.

# Tests
thor test:all       # Run all tests

# Assets
thor assets:compile # Compile assets (not required in development mode)
thor assets:clean   # Clean old assets
```

## Contributing

Contributions are welcome. Please read the [contributing guidelines](https://github.com/Thibaut/devdocs/blob/master/CONTRIBUTING.md).

## Copyright / License

Copyright 2013 Thibaut Courouble and [other contributors](https://github.com/Thibaut/devdocs/graphs/contributors)

This software is licensed under the terms of the Mozilla Public License v2.0. See the [COPYRIGHT](https://github.com/Thibaut/devdocs/blob/master/COPYRIGHT) and [LICENSE](https://github.com/Thibaut/devdocs/blob/master/LICENSE) files.

**Note:** I consider _DevDocs_ to be a trademark. You may not use the name to endorse or promote products derived from this software without my permission, except as may be necessary to comply with the notice/attribution requirements.

**Additionally**, I wish that any documentation file generated using this software be attributed to DevDocs. Let's be fair to all contributors by not stealing their hard work.

## Questions?

If you have any questions, please feel free to ask on the [mailing list](https://groups.google.com/d/forum/devdocs).
