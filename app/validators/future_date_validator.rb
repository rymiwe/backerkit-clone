# frozen_string_literal: true

# Validates that a date attribute is in the future
# This ensures better validation messaging for date fields
class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    return unless value <= Date.current

    record.errors.add(attribute, options[:message] || "must be a future date")
  end
end
