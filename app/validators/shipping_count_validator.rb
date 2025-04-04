# frozen_string_literal: true

# Custom validator to ensure that shipped counts don't exceed produced counts
# This helps maintain data integrity in the fulfillment process
class ShippingCountValidator < ActiveModel::Validator
  def validate(record)
    # Make sure these attributes are present
    return unless record.respond_to?(:shipped_count) && record.respond_to?(:produced_count)

    # IMPORTANT: Even in test environment, we always validate that shipped_count can't exceed produced_count
    # This is a critical business rule that should always be enforced
    if record.shipped_count.to_i > record.produced_count.to_i
      record.errors.add(:shipped_count, "cannot exceed the produced count (#{record.produced_count})")
    end

    # Skip remaining validations during seed process if environment variable is set
    return if ENV['SKIP_SHIPPING_VALIDATION'] == 'true'

    # Check if we're trying to produce more items than needed
    if record.respond_to?(:total_needed) && record.total_needed.to_i > 0 && record.produced_count.to_i > record.total_needed.to_i
      record.errors.add(:produced_count, "cannot exceed the total needed count (#{record.total_needed})")
    end

    # Check if any counts are negative
    record.errors.add(:shipped_count, "cannot be negative") if record.shipped_count.to_i.negative?
    record.errors.add(:produced_count, "cannot be negative") if record.produced_count.to_i.negative?
  end
end
