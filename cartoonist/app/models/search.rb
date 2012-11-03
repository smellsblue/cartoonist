class Search
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def results
    return [] if @query.blank?
    @results ||= entity_results + searchable_results
  end

  private
  def entity_results
    Cartoonist::Entity.all.map do |entity|
      if entity.respond_to? :search
        entity.search(@query).map { |x| Search::EntityResult.new x }
      else
        []
      end
    end.flatten
  end

  def searchable_results
    Cartoonist::Searchable.all.map do |searchable|
      searchable.search(@query).map { |x| Search::SearchableResult.new x }
    end.flatten
  end

  class << self
    def query(params)
      new params[:q]
    end
  end

  class EntityResult
    include BelongsToEntity

    def initialize(entity)
      @entity = entity
    end

    def url
      entity.search_url
    end
  end

  class SearchableResult
    attr_reader :searchable

    def initialize(searchable)
      @searchable = searchable
    end

    def description
      searchable.description
    end

    def url
      searchable.search_url
    end
  end
end
