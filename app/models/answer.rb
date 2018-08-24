class Answer < ApplicationRecord
  belongs_to(:statement, dependent: :destroy)

  validate :selected_choices_references

  def self.with_choice(id)
    choice = Choice.find(id)
    answers = choice.statement.answers
    answers.select do |answer|
      answer.choices.where(id: id).exists?
    end
  end

  def choices
    Choice.where(id: selected_choices_ids)
  end

  def selected_choices_ids
    extract_choices_from_array_notation.split(',').map(&:to_i)
  end

  private

  def selected_choices_numbers?
    extract_choices_from_array_notation.split(',').each do |s|
      return false if !number? s
    end
    true
  end

  def extract_choices_from_array_notation
    matching_array = selected_choices.match(/\[(.*)\]/)
    return '' if matching_array.nil?
    matching_array[1]
  end

  def number? string
    true if Float(string) rescue false
  end

  def selected_choices_references
    has_choice_reference = []

    return true if selected_choices == '[]' # allow answers without choice

    if !extract_choices_from_array_notation.empty?
      if selected_choices_numbers?
        has_choice_reference = selected_choices_ids.map { |id| Choice.where(id: id).any? }
      else
        errors.add(:selected_choices, 'ids enthalten ungültige Zeichen!')
        return false
      end
    else
      errors.add(:selected_choices, 'string nicht in Array format')
      return false
    end

    # Check for non-existing choices
    if has_choice_reference.include? false
      errors.add(:selected_choices, 'enthält ungültige Referenzen!')
    end

    # Check that all choices refer to same statement
    if choices.pluck(:statement_id).uniq.count > 1
      errors.add(:selected_choices, 'enthält Referenzen auf unterschiedliche Statements!')
      return nil
    end

    return false
  end
end
