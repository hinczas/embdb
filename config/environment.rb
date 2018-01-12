# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS.merge!(  
:default => '%e %b %Y %H:%M' )
Date::DATE_FORMATS.merge!(  
:default => '%e-%b-%Y' )

Mime::Type.register "application/schematics", :sch
Mime::Type.register "application/board", :brd
Mime::Type.register "text/tsv", :tsv
