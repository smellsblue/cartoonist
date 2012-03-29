class AdminController < ApplicationController
  before_filter :ensure_ssl!, :except => [:cache_cron, :tweet_cron]
  before_filter :check_admin!, :except => [:cache_cron, :index, :sign_in, :tweet_cron]

  def index
    redirect_to "/admin/sign_in"
  end

  def backup
    respond_to do |format|
      format.html { redirect_to "/admin/main" }
      format.json do
        prefix = "dev-" unless Rails.env.production?
        filename = "#{prefix}comics-backup-#{Time.now.strftime("%Y-%m-%d_%H%M%S")}.json"
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
        content = { :comics => Comic.order(:id).all, :files => DatabaseFile.order(:id).all, :blog_posts => BlogPost.order(:id).all, :pages => Page.order(:id).all }
        render :text => content.to_json, :content_type => "application/json"
      end
    end
  end

  def reload
    if Rails.env.production?
      %x[git pull]
      %x[touch #{File.join Rails.root, "tmp/restart.txt"}]
      flash[:message] = "Updated and restarted."
    end

    redirect_to "/admin/main"
  end

  def main
    render :layout => "admin"
  end

  def cache_cron
    Dir.glob(File.join(Rails.root, "public/cache/**/*.tmp.html*"), File::FNM_DOTMATCH).each do |file|
      if 2.hours.ago > File.mtime(file)
        File.delete file
      end
    end

    render :text => "Success.", :layout => false
  rescue
    render :text => "Failure.", :layout => false
  end

  def tweet_cron
    messages = []

    Comic.untweeted.each do |comic|
      comic.tweet!
      messages << "Comic: #{comic.tweet}"
    end

    BlogPost.untweeted.each do |post|
      post.tweet!
      messages << "Blog Post: #{post.tweet}"
    end

    unless Rails.env.production?
      content = "#{messages.join "\n"}\n"
    end

    render :text => "#{content}Success.", :layout => false
  rescue
    render :text => "Failure.", :layout => false
  end

  def sign_in
    return redirect_to "/admin/main" if session[:admin]

    if request.post?
      user = Cartoonist::Application.config.admin_users[params[:username]]

      if user && params[:password] == user[:password]
        session[:admin] = true
        session[:user] = user[:name]
        return redirect_to "/admin/main"
      else
        flash[:error] = "Wrong username or password!"
        return redirect_to "/admin/sign_in"
      end
    end

    render :layout => "sign_in"
  end

  def logout
    reset_session
    redirect_to "/admin/sign_in"
  end
end
