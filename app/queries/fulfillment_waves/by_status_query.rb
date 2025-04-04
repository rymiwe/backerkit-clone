module FulfillmentWaves
  # Query object for filtering fulfillment waves by status
  # This encapsulates query logic in a dedicated object, making the code more maintainable
  class ByStatusQuery
    def initialize(relation = FulfillmentWave.all)
      @relation = relation
    end

    # Filter waves by status with ordering options
    # @param status [String, Symbol, Array] The status or statuses to filter by
    # @param order [Symbol] The order direction (:asc or :desc)
    # @param order_by [Symbol] The field to order by (default: :target_ship_date)
    # @return [ActiveRecord::Relation] The filtered and ordered relation
    def call(status:, order: :desc, order_by: :target_ship_date)
      # Status can be a single value or an array of values
      result = relation.where(status: status)
      result.order(order_by => order)
    end

    # Find waves that have items with specific production priorities
    # @param priority [Integer, Array] The priority value(s) to filter by
    # @return [ActiveRecord::Relation] Waves containing items with the specified priority
    def with_priority(priority:)
      relation.joins(wave_items: :reward_item)
              .where(reward_items: { production_priority: priority })
              .distinct
    end

    # Find waves targeting shipping within a specific date range
    # @param start_date [Date] The beginning of the date range
    # @param end_date [Date] The end of the date range
    # @return [ActiveRecord::Relation] Waves with target shipping dates in the range
    def shipping_between(start_date:, end_date:)
      relation.where(target_ship_date: start_date..end_date)
    end

    # Find waves that are behind schedule (past target date but not completed)
    # @return [ActiveRecord::Relation] Waves that are behind schedule
    def behind_schedule
      relation.where('target_ship_date < ? AND status != ?', Date.current, 'completed')
    end

    private

    attr_reader :relation
  end
end
