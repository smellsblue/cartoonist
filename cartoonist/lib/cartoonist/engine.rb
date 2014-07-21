require "actionpack/page_caching"

module Cartoonist
  class Engine < ::Rails::Engine
    # Use this hook to configure devise mailer, warden hooks and so forth.
    # Many of these configuration options can be set straight in your model.
    Devise.setup do |devise_config|
      devise_config.parent_controller = "CartoonistController"

      # ==> Mailer Configuration
      # Configure the e-mail address which will be shown in Devise::Mailer,
      # note that it will be overwritten if you use your own mailer class with default "from" parameter.
      devise_config.mailer_sender = "no-reply@willbesetlater.com"

      # Configure the class responsible to send e-mails.
      # devise_config.mailer = "Devise::Mailer"

      # ==> ORM configuration
      # Load and configure the ORM. Supports :active_record (default) and
      # :mongoid (bson_ext recommended) by default. Other ORMs may be
      # available as additional gems.
      require "devise/orm/active_record"

      # ==> Configuration for any authentication mechanism
      # Configure which keys are used when authenticating a user. The default is
      # just :email. You can configure it to use [:username, :subdomain], so for
      # authenticating a user, both parameters are required. Remember that those
      # parameters are used only when authenticating and not when retrieving from
      # session. If you need permissions, you should implement that in a before filter.
      # You can also supply a hash where the value is a boolean determining whether
      # or not authentication should be aborted when the value is not present.
      # devise_config.authentication_keys = [ :email ]

      # Configure parameters from the request object used for authentication. Each entry
      # given should be a request method and it will automatically be passed to the
      # find_for_authentication method and considered in your model lookup. For instance,
      # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
      # The same considerations mentioned for authentication_keys also apply to request_keys.
      # devise_config.request_keys = []

      # Configure which authentication keys should be case-insensitive.
      # These keys will be downcased upon creating or modifying a user and when used
      # to authenticate or find a user. Default is :email.
      devise_config.case_insensitive_keys = [ :email ]

      # Configure which authentication keys should have whitespace stripped.
      # These keys will have whitespace before and after removed upon creating or
      # modifying a user and when used to authenticate or find a user. Default is :email.
      devise_config.strip_whitespace_keys = [ :email ]

      # Tell if authentication through request.params is enabled. True by default.
      # It can be set to an array that will enable params authentication only for the
      # given strategies, for example, `devise_config.params_authenticatable = [:database]` will
      # enable it only for database (email + password) authentication.
      # devise_config.params_authenticatable = true

      # Tell if authentication through HTTP Basic Auth is enabled. False by default.
      # It can be set to an array that will enable http authentication only for the
      # given strategies, for example, `devise_config.http_authenticatable = [:token]` will
      # enable it only for token authentication.
      # devise_config.http_authenticatable = false

      # If http headers should be returned for AJAX requests. True by default.
      # devise_config.http_authenticatable_on_xhr = true

      # The realm used in Http Basic Authentication. "Application" by default.
      # devise_config.http_authentication_realm = "Application"

      # It will change confirmation, password recovery and other workflows
      # to behave the same regardless if the e-mail provided was right or wrong.
      # Does not affect registerable.
      # devise_config.paranoid = true

      # By default Devise will store the user in session. You can skip storage for
      # :http_auth and :token_auth by adding those symbols to the array below.
      # Notice that if you are skipping storage for all authentication paths, you
      # may want to disable generating routes to Devise's sessions controller by
      # passing :skip => :sessions to `devise_for` in your config/routes.rb
      devise_config.skip_session_storage = [:http_auth]

      # ==> Configuration for :database_authenticatable
      # For bcrypt, this is the cost for hashing the password and defaults to 10. If
      # using other encryptors, it sets how many times you want the password re-encrypted.
      #
      # Limiting the stretches to just one in testing will increase the performance of
      # your test suite dramatically. However, it is STRONGLY RECOMMENDED to not use
      # a value less than 10 in other environments.
      devise_config.stretches = Rails.env.test? ? 1 : 10

      # Setup a pepper to generate the encrypted password.
      devise_config.pepper = "temporary... this is initialized later, in the to_prepare block"
      devise_config.secret_key = "temporary... this is initialized later, in the to_prepare block"

      # ==> Configuration for :confirmable
      # A period that the user is allowed to access the website even without
      # confirming his account. For instance, if set to 2.days, the user will be
      # able to access the website for two days without confirming his account,
      # access will be blocked just in the third day. Default is 0.days, meaning
      # the user cannot access the website without confirming his account.
      # devise_config.allow_unconfirmed_access_for = 2.days

      # If true, requires any email changes to be confirmed (exctly the same way as
      # initial account confirmation) to be applied. Requires additional unconfirmed_email
      # db field (see migrations). Until confirmed new email is stored in
      # unconfirmed email column, and copied to email column on successful confirmation.
      devise_config.reconfirmable = true

      # Defines which key will be used when confirming an account
      # devise_config.confirmation_keys = [ :email ]

      # ==> Configuration for :rememberable
      # The time the user will be remembered without asking for credentials again.
      # devise_config.remember_for = 2.weeks

      # If true, extends the user's remember period when remembered via cookie.
      # devise_config.extend_remember_period = false

      # Options to be passed to the created cookie. For instance, you can set
      # :secure => true in order to force SSL only cookies.
      # devise_config.cookie_options = {}

      # ==> Configuration for :validatable
      # Range for password length. Default is 6..128.
      # devise_config.password_length = 6..128

      # Email regex used to validate email formats. It simply asserts that
      # an one (and only one) @ exists in the given string. This is mainly
      # to give user feedback and not to assert the e-mail validity.
      # devise_config.email_regexp = /\A[^@]+@[^@]+\z/

      # ==> Configuration for :timeoutable
      # The time you want to timeout the user session without activity. After this
      # time the user will be asked for credentials again. Default is 30 minutes.
      # devise_config.timeout_in = 30.minutes

      # ==> Configuration for :lockable
      # Defines which strategy will be used to lock an account.
      # :failed_attempts = Locks an account after a number of failed attempts to sign in.
      # :none            = No lock strategy. You should handle locking by yourself.
      # devise_config.lock_strategy = :failed_attempts

      # Defines which key will be used when locking and unlocking an account
      # devise_config.unlock_keys = [ :email ]

      # Defines which strategy will be used to unlock an account.
      # :email = Sends an unlock link to the user email
      # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
      # :both  = Enables both strategies
      # :none  = No unlock strategy. You should handle unlocking by yourself.
      # devise_config.unlock_strategy = :both

      # Number of authentication tries before locking an account if lock_strategy
      # is failed attempts.
      # devise_config.maximum_attempts = 20

      # Time interval to unlock the account if :time is enabled as unlock_strategy.
      # devise_config.unlock_in = 1.hour

      # ==> Configuration for :recoverable
      #
      # Defines which key will be used when recovering the password for an account
      # devise_config.reset_password_keys = [ :email ]

      # Time interval you can reset your password with a reset password key.
      # Don't put a too small interval or your users won't have the time to
      # change their passwords.
      devise_config.reset_password_within = 6.hours

      # ==> Configuration for :encryptable
      # Allow you to use another encryption algorithm besides bcrypt (default). You can use
      # :sha1, :sha512 or encryptors from others authentication tools as :clearance_sha1,
      # :authlogic_sha512 (then you should set stretches above to 20 for default behavior)
      # and :restful_authentication_sha1 (then you should set stretches to 10, and copy
      # REST_AUTH_SITE_KEY to pepper)
      # devise_config.encryptor = :sha512

      # ==> Configuration for :token_authenticatable
      # Defines name of the authentication token params key
      # devise_config.token_authentication_key = :auth_token

      # ==> Scopes configuration
      # Turn scoped views on. Before rendering "sessions/new", it will first check for
      # "users/sessions/new". It's turned off by default because it's slower if you
      # are using only default views.
      # devise_config.scoped_views = false

      # Configure the default scope given to Warden. By default it's the first
      # devise role declared in your routes (usually :user).
      # devise_config.default_scope = :user

      # Configure sign_out behavior.
      # Sign_out action can be scoped (i.e. /users/sign_out affects only :user scope).
      # The default is true, which means any logout action will sign out all active scopes.
      # devise_config.sign_out_all_scopes = true

      # ==> Navigation configuration
      # Lists the formats that should be treated as navigational. Formats like
      # :html, should redirect to the sign in page when the user does not have
      # access, but formats like :xml or :json, should return 401.
      #
      # If you have any extra navigational formats, like :iphone or :mobile, you
      # should add them to the navigational formats lists.
      #
      # The "*/*" below is required to match Internet Explorer requests.
      # devise_config.navigational_formats = ["*/*", :html]

      # The default HTTP method used to sign out a resource. Default is :delete.
      devise_config.sign_out_via = :delete

      # ==> OmniAuth
      # Add a new OmniAuth provider. Check the wiki for more information on setting
      # up on your models and hooks.
      # devise_config.omniauth :github, 'APP_ID', 'APP_SECRET', :scope => 'user,public_repo'

      # ==> Warden configuration
      # If you want to use other strategies, that are not supported by Devise, or
      # change the failure app, you can configure them inside the devise_config.warden block.
      #
      # devise_config.warden do |manager|
      #   manager.intercept_401 = false
      #   manager.default_strategies(:scope => :user).unshift :some_external_strategy
      # end

      devise_config.omniauth :openid, :name => "google", :identifier => "https://www.google.com/accounts/o8/id", :store => OpenID::Store::Filesystem.new("/tmp")
    end

    config.before_initialize do
      # Add in various configuration from plugins
      Rails.application.config.assets.precompile += ["admin.css", "cartoonist.js"]
      Rails.application.config.assets.precompile += Cartoonist::Asset.all
      Rails.application.config.action_controller.page_cache_directory = File.join Rails.root, "public"

      Cartoonist::Migration.all.flatten.each do |path|
        Rails.application.config.paths["db/migrate"] << path
      end

      Rails.application.config.action_controller.include_all_helpers = false

      if File.directory? File.join(Rails.root, "public/errors")
        Rails.application.config.exceptions_app = ActionDispatch::PublicExceptions.new(File.join Rails.root, "public/errors")
      else
        Rails.application.config.exceptions_app = ActionDispatch::PublicExceptions.new(File.join File.dirname(__FILE__), "../../public/errors")
      end

      # Public expire headers causes our action to not be called until cache expires
      Rails.application.config.action_dispatch.rack_cache = nil
    end

    config.to_prepare do
      Devise::SessionsController.layout "users"

      secret_token_changed = lambda do
        # Your secret key for verifying the integrity of signed cookies.
        # If you change this key, all old signed cookies will become invalid!
        # Make sure the secret is at least 30 characters and all random,
        # no regular words or you'll be exposed to dictionary attacks.
        Rails.application.config.secret_token = Setting[:secret_token]
      end

      secret_key_base_changed = lambda do
        # Your secret key for verifying the integrity of signed cookies.
        # If you change this key, all old signed cookies will become invalid!
        # Make sure the secret is at least 64 characters and all random,
        # no regular words or you'll be exposed to dictionary attacks.
        Rails.application.config.secret_key_base = Setting[:secret_key_base]
      end

      devise_pepper_changed = lambda do
        Devise.setup do |devise_config|
          devise_config.mailer_sender = "no-reply@#{Setting[:domain]}"
          devise_config.pepper = Setting[:devise_pepper]
        end
      end

      devise_secret_key_changed = lambda do
        Devise.setup do |devise_config|
          devise_config.secret_key = Setting[:devise_secret_key]
        end
      end

      Setting.define :domain, :order => 1
      Setting.define :site_name, :order => 2
      Setting.define :site_heading, :order => 3
      Setting.define :site_update_description, :order => 4
      Setting.define :root_path, :type => :symbol, :default => Cartoonist::RootPath.all.first, :order => 5, :select_from => lambda { Cartoonist::RootPath.all }, :onchange => lambda { Rails.application.reload_routes! }
      Setting.define :theme, :type => :symbol, :default => :cartoonist_default_theme, :order => 6, :select_from => lambda { Cartoonist::Theme.all }
      Setting.define :schedule, :type => :array, :default => [:monday, :wednesday, :friday], :order => 7, :select_from => [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
      Setting.define :copyright_starting_year, :type => :int, :order => 8
      Setting.define :copyright_owners, :order => 9

      Setting::Tab.define :social_and_analytics, :order => 1 do
        Setting::Section.define :google_analytics, :order => 1 do
          Setting.define :google_analytics_enabled, :type => :boolean, :order => 1
          Setting.define :google_analytics_account, :order => 2
        end

        Setting::Section.define :disqus, :order => 3 do
          Setting.define :disqus_enabled, :type => :boolean, :order => 1
          Setting.define :disqus_shortname, :order => 2
          Setting.define :disqus_comic_category, :order => 3
          Setting.define :disqus_blog_post_category, :order => 4
          Setting.define :disqus_page_category, :order => 5
        end
      end

      Setting::Tab.define :advanced, :order => 2 do
        Setting.define :secret_token, :default => "ThisTokenMustBeRegenerated....", :onchange => secret_token_changed
        Setting.define :secret_key_base, :default => "ThisTokenMustBeRegenerated....", :onchange => secret_key_base_changed
        Setting.define :devise_pepper, :default => "ThisTokenMustBeRegenerated....", :onchange => devise_pepper_changed
        Setting.define :devise_secret_key, :default => "ThisTokenMustBeRegenerated....", :onchange => devise_secret_key_changed
      end

      if Setting.table_exists?
        secret_token_changed.call
        secret_key_base_changed.call
        devise_pepper_changed.call
        devise_secret_key_changed.call
      end
    end

    Mime::Type.register "image/x-icon", :ico
    Mime::Type.register "application/octet-stream", :tgz
    Cartoonist::Admin::Tab.add :general, :url => "/admin", :order => 3
    Cartoonist::Admin::Tab.add :sites, :url => "/admin/sites", :order => 4
    Cartoonist::Asset.add "admin/search.js"
    Cartoonist::Migration.add_for self

    Cartoonist::Backup.for :files do
      DatabaseFile.order(:id)
    end

    Cartoonist::Backup.for :settings do
      Setting.order(:id)
    end

    Cartoonist::Backup.for :users do
      User.order(:id)
    end

    Cartoonist::Cron.add do
      PageCache.cleanup_tmp!
    end

    Cartoonist::Routes.add_begin do
      root :to => Cartoonist::RootPath.current
    end

    Cartoonist::Routes.add do
      get "favicon" => "site#favicon", :defaults => { :format => "ico" }
      get "sitemap" => "site#sitemap", :defaults => { :format => "xml" }
      get "robots" => "site#robots", :defaults => { :format => "text" }
      get "admin/backup" => "backup#backup"

      resource :admin, :controller => :admin, :only => [:show] do
        collection do
          get "cron"
          get "main"
          get "reload"
        end
      end

      devise_for :users, :controllers => { :omniauth_callbacks => "admin/omniauth_callbacks" }

      namespace :admin do
        # For some reason, "new" is being treated as "show" so
        # restrict id to digits
        resources :accounts, :constraints => { :id => /\d*/ }
        resources :domains, :only => [:destroy]

        resources :cache, :constraints => { :id => /.*/ }, :only => [:destroy, :index] do
          collection do
            post "expire_www"
            post "expire_tmp"
            post "expire_all"
          end
        end

        resources :sites, :only => [:index, :new, :create, :show, :edit, :update]

        resources :static_cache, :constraints => { :id => /.*/ }, :only => [:destroy, :index] do
          collection do
            post "expire_all"
          end
        end

        resources :settings, :only => [:index, :show, :update] do
          collection do
            get "initial_setup"
            post "save_initial_setup"
          end
        end

        resources :search, :only => [:index]
      end
    end
  end
end
