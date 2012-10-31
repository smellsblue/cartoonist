class Search
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def results
    return [] if @query.blank?
    @results ||= Cartoonist::Entity.all.map do |entity|
      if entity.respond_to? :search
        entity.search(@query).map { |x| Search::Result.new x }
      else
        []
      end
    end.flatten
  end

  class << self
    def query(params)
      new params[:q]
    end
  end

  class Result
    include BelongsToEntity

    def initialize(entity)
      @entity = entity
    end

    def url
      entity.edit_url
    end
  end
end
