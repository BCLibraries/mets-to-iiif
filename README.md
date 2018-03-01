# Metsiiif

Builds a IIIF manifest from a Boston College Libraries METS file. Right now this gem is specific to BC's METS application profile.

## Installation

To use the command line tool you will need to install locally. Clone or download this repository and install the gem:

    $ git clone https://github.com/BCLibraries/mets-to-iiif
    $ cd mets-to-iiif
    $ gem build metsiiif.gemspec
    $ gem install ./metsiiif-x.x.x.gem
    
## Usage

To run on the command line:

    $ metsiiif /path/to/mets/file/here > manifest.json

Or use a 'for' loop to generate several manifests:

    $ for file in /path/to/mets/*.xml; do metsiiif $file > `basename $file .xml`.json; done

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/metsiiif. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Metsiiif project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/metsiiif/blob/master/CODE_OF_CONDUCT.md).
