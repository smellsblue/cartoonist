Nginxtra::Config::Extension.partial "nginx.conf", "cartoonist_rails" do |args, block|
  rails_server = args[:server] || :passenger
  ssl_details = args[:ssl]

  if ssl_details
    default_port = 443
  else
    default_port = 80
  end

  if rails_server == :passenger && !@passenger_requirements_done
    @config.require_passenger!
    passenger_root!
    passenger_ruby!
    @passenger_requirements_done = true
  end

  server do
    listen(args[:port] || default_port)
    server_name(args[:server_name] || "localhost")
    root File.join(File.absolute_path(File.expand_path(args[:root] || ".")), "public")
    gzip_static "on"
    passenger_on! if rails_server == :passenger
    rails_env(args[:environment] || "production")

    if ssl_details
      ssl "on"
      ssl_certificate ssl_details[:ssl_cert]
      ssl_certificate_key ssl_details[:ssl_key]
      @config.compile_option "--with-http_ssl_module"
    end

    block.call
  end
end

Nginxtra::Config::Extension.partial "nginx.conf", "cartoonist" do |args, block|
  if !@passenger_requirements_done
    @config.require_passenger!
    passenger_root!
    passenger_ruby!
    @passenger_requirements_done = true
  end

  cartoonist_type = args[:type] || "www"
  server_name = args[:server_name]
  root_path = args[:root]
  ssl_details = args[:ssl]
  ssl_details = { :ssl => ssl_details } if ssl_details
  short_expiration = args[:short_expiration] || "2h"
  long_expiration = args[:long_expiration] || "7d"

  [{}, ssl_details].compact.each do |additional_options|
    options = { :server => :custom, :server_name => server_name, :root => root_path }.merge additional_options

    cartoonist_rails options do
      location "~*", "^/_long_expiration_/#{cartoonist_type}(/.*?)(?:\\.html)?$" do
        expires long_expiration
        add_header "Cache-Control", "public"
        try_files "$1", "$1.html", "/cache/static$1", "@passenger"
      end

      ["/cache/static$uri", "$uri", "$uri.html"].each do |condition|
        _if "-f #{root_path}/public#{condition}" do
          rewrite "^(.*)$", "/_long_expiration_/#{cartoonist_type}$1", "last"
        end
      end

      ["html", "json", "rss"].each do |extension|
        location "~*", "^/_short_#{extension}_expiration_/#{cartoonist_type}(/.*?)(?:\\.#{extension})?$" do
          expires short_expiration
          add_header "Cache-Control", "public"
          try_files "/cache$1.#{cartoonist_type}.tmp.#{extension}", "@passenger"
        end

        location "~*", "^/_long_#{extension}_expiration_/#{cartoonist_type}(/.*?)(?:\\.#{extension})?$" do
          expires long_expiration
          add_header "Cache-Control", "public"
          try_files "/cache$1.#{cartoonist_type}.#{extension}", "@passenger"
        end

        _if "-f #{root_path}/public/cache$uri.#{cartoonist_type}.tmp.#{extension}" do
          rewrite "^(.*)$", "/_short_#{extension}_expiration_/#{cartoonist_type}$1", "last"
        end

        _if "-f #{root_path}/public/cache$uri.#{cartoonist_type}.#{extension}" do
          rewrite "^(.*)$", "/_long_#{extension}_expiration_/#{cartoonist_type}$1", "last"
        end
      end

      location "/" do
        try_files "/_jump_to_passenger_", "@passenger"
      end

      location "@passenger" do
        passenger_on!
      end
    end
  end
end
