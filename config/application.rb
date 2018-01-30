require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.version = "0.36.2"
    config.p_sort  = nil
    config.p_dir  = nil
    config.m_sort = nil
    config.m_dir  = nil
    config.b_sort = nil
    config.b_dir  = nil
    config.pcb_sort = nil
    config.pcb_dir  = nil
    config.pr_sort = nil
    config.pr_dir  = nil
    config.movies_layout  = "list"
    config.books_layout  = "list"
    config.active_record.raise_in_transactional_callbacks = true
    config.developer = "false"
  end
end
