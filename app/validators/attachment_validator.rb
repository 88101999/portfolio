class AttachmentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    has_error = false

    if options[:maximum]
      has_error = true unless validate_maximum(record, attribute, value)
    end

    if options[:content_type]
      has_error = true unless validate_content_type(record, attribute, value)
    end

    value.purge if has_error && options[:purge]
  end

  private

  def validate_maximum(record, attribute, value)
    if value.blob.byte_size > options[:maximum]
      record.errors.add(
        attribute,
        :maximum,
        max_size: number_to_human_size(options[:maximum])
      )
      return false
    end
    true
  end

  def validate_content_type(record, attribute, value)
    unless value.blob.content_type.match?(options[:content_type])
      record.errors.add(attribute, :content_type)
      return false
    end
    true
  end

  def number_to_human_size(size)
    if size < 1024
      "#{size} Bytes"
    elsif size < 1024 * 1024
      "#{(size / 1024.0).round(2)} KB"
    else
      "#{(size / (1024.0 * 1024)).round(2)} MB"
    end
  end
end