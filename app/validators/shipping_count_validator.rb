# frozen_string_literal: true

# Custom validator to ensure that shipped counts don't exceed produced counts
# This helps maintain data integrity in the fulfillment process
class ShippingCountValidator < ActiveModel::Validator
  def validate(record)
    # Skip validation during seed process if environment variable is set
    return if ENV['SKIP_SHIPPING_VALIDATION'] == 'true'
    
    # Skip validation if the record is new or these attributes aren't present
    return unless record.persisted? && record.respond_to?(:shipped_count) && record.respond_to?(:produced_count)

    # Check if we're trying to ship more items than we've produced
    if record.shipped_count.to_i > record.produced_count.to_i
      record.errors.add(:shipped_count, "cannot exceed the produced count (#{record.produced_count})")
    end

    # Check if we're trying to produce more items than needed
    if record.respond_to?(:total_needed) && record.produced_count.to_i > record.total_needed.to_i
      record.errors.add(:produced_count, "cannot exceed the total needed count (#{record.total_needed})")
    end

    # Check if any counts are negative
    record.errors.add(:shipped_count, "cannot be negative") if record.shipped_count.to_i.negative?
    record.errors.add(:produced_count, "cannot be negative") if record.produced_count.to_i.negative?
  end
end
