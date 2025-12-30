![Gravatar Logo](http://s.gravatar.com/images/logo.png "Gravatar Logo")

# Gravatar Image Tag Plugin

Rails view helper for grabbing [Gravatar](http://en.gravatar.com/)
images. The goal here is to be configurable and have those configuration
points documented!

## Install as a Ruby Gem

### Rails 2

Include the following line in your Rails environment

    # config/environment
      config.gem 'gravatar_image_tag'

Then ensure the gem is installed by running the following rake task from
the your application root.

    rake gems:install

### Rails 3

Include the following line in your Rails environment

    # Gemfile
      gem 'gravatar_image_tag'

Then ensure the gem is installed by running the following command from
the application root.

    bundle install

## Install as a Ruby on Rails Plugin

    ./script/plugin install git://github.com/mdeering/gravatar_image_tag.git

## Usage

### Gravatar Image Tag

Once you have installed it as a plugin for your rails app usage is
simple.

    gravatar_image_tag('spam@spam.com'.gsub('spam', 'mdeering'), :alt => 'Michael Deering')

**Boom** here is my gravatar
![Michael Deering](http://www.gravatar.com/avatar/4da9ad2bd4a2d1ce3c428e32c423588a "Michael Deering")

### Gravatar Image URL

You can also return just the Gravatar URL:

    gravatar_image_url('spam@spam.com'.gsub('spam', 'mdeering'), filetype: :png, rating: 'pg', size: 15, secure:false )

Useful when used in your inline CSS.

    <div class="gravatar" style="background:transparent url(<%= gravatar_image_url('spam@spam.com'.gsub('spam', 'mdeering'), size: 100) %>) 0px 0px no-repeat; width:100px; height:100px;"></div>

## Configuration

### Global configuration points

    # config/initializers/gravatar_image_tag.rb
    GravatarImageTag.configure do |config|
      config.default_image           = nil   # Set this to use your own default gravatar image rather then serving up Gravatar's default image [ 'http://example.com/images/default_gravitar.jpg', :identicon, :monsterid, :wavatar, 404 ].
      config.filetype                = nil   # Set this if you require a specific image file format ['gif', 'jpg' or 'png'].  Gravatar's default is png
      config.include_size_attributes = true  # The height and width attributes of the generated img will be set to avoid page jitter as the gravatars load.  Set to false to leave these attributes off.
      config.rating                  = nil   # Set this if you change the rating of the images that will be returned ['G', 'PG', 'R', 'X']. Gravatar's default is G
      config.size                    = nil   # Set this to globally set the size of the gravatar image returned (1..512). Gravatar's default is 80
      config.secure                  = false # Set this to true if you require secure images on your pages.
    end

### Setting the default image inline

**Splat** the default gravatar image
![Default Gravatar Image](http://www.gravatar.com/avatar/0c821f675f132d790b3f25e79da739a7 "Default Gravatar Image")

You can set the default gravatar image inline as follows:

    gravatar_image_tag('junk', :alt => 'Github Default Gravatar', :gravatar => { :default => 'https://assets.github.com/images/gravatars/gravatar-140.png' })

**Ka-Pow**
![Github Default Gravatar](https://assets.github.com/images/gravatars/gravatar-140.png "Github Default Gravatar")

Other options supported besides an image url to fall back on include the
following:

-   :identicon
    ![Identicon Avatar](http://www.gravatar.com/avatar/0c821f675f132d790b3f25e79da739a7?default=identicon "Identicon Avatar")
-   :monsterid
    ![Monster Id Avatar](http://www.gravatar.com/avatar/0c821f675f132d790b3f25e79da739a7?default=monsterid "Monster Id Avatar")
-   :wavatar
    ![Wavatar Avatar](http://www.gravatar.com/avatar/0c821f675f132d790b3f25e79da739a7?default=wavatar "Wavatar Avatar")
-   404:
    ![Not Found](http://www.gravatar.com/avatar/0c821f675f132d790b3f25e79da739a7?default=404 "Not Found")

### Setting the default image size

You can set the gravatar image size inline as follows:

    gravatar_image_tag('spam@spam.com'.gsub('spam', 'mdeering'), :alt => 'Michael Deering', :class => 'some-class', :gravatar => { :size => 15 })

**Mini Me!**
![Michael Deering](http://www.gravatar.com/avatar/4da9ad2bd4a2d1ce3c428e32c423588a?size=15 "Michael Deering"){.some-class}

### Grabbing gravatars from the secure gravatar server.

You can make a request for a gravatar from the secure server at
https://secure.gravatar.com by passing the *:gravatar =\> { :secure =\>
true }* option to the gravatar_image_tag call.

    gravatar_image_tag('spam@spam.com'.gsub('spam', 'mdeering'), :alt => 'Michael Deering', :gravatar => { :secure => true } )

Delivered by a secure url!
![Michael Deering](https://secure.gravatar.com/avatar/4da9ad2bd4a2d1ce3c428e32c423588a "Michael Deering")

### Using Gravatar's built in rating system

You can set the gravatar rating inline as follows:

    gravatar_image_tag('spam@spam.com'.gsub('spam', 'mdeering'), :alt => 'Michael Deering', :gravatar => { :rating => 'pg' } )

### Specifying a filetype

You can set the gravatar filetype inline as follows:

    gravatar_image_tag('spam@spam.com'.gsub('spam', 'mdeering'), :alt => 'Michael Deering', :gravatar => { :filetype => :gif } )

## Credits

The ideas and methods for this plugin are from expanding upon my
original blog post [Adding Gravatar To Your Website Or Blog (Gravatar
Rails)](http://mdeering.com/posts/005-adding-gravitar-to-your-website-or-blog)

Copyright © 2009-2010 [Michael Deering(Ruby on Rails Development
Edmonton)](http://mdeering.com), released under the MIT license
