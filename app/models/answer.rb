class Answer < ApplicationRecord
  belongs_to(:statement, dependent: :destroy)

  validate :selected_choices_references

  def selected_choices_inst
    Choice.where(id: selected_choices_ids)
  end

  def selected_choices_ids
    extract_choices_from_array_notation.split(',').map(&:to_i)
  end

  private

  def selected_choices_numbers?
    extract_choices_from_array_notation.split(',').each do |s|
      if !number? s
        return false
      end
    end
    true
  end

  def selected_choices_numbers2?
    extract_choices_from_array_notation.split(',').map { |id| !number? id}.include? true
  end
  def extract_choices_from_array_notation
    matching_array = selected_choices.match(/\[(.*)\]/)
    if matching_array.nil?
      return ""
    end
    matching_array[1]

  end

  def number? string
      true if Float(string) rescue false
  end

  def selected_choices_references
    has_choice_reference = []
    if !extract_choices_from_array_notation.empty?
      if selected_choices_numbers?
        has_choice_reference = selected_choices_ids.map { |id| Choice.where(id: id).any? }
      else 
        errors.add(:selected_choices, 'Choice Ids enthalten Characters!')
        return false
      end
    else
      errors.add(:selected_choices, 'Selected Choices String nicht in Array format')
      return false
    end

    # Check that at least on reference
    if selected_choices_ids.empty?
      errors.add(:selected_choices, 'Auswahl muss mindestens ein Element enthalten!')
    end

    # Check for non-existing choices
    if has_choice_reference.include? false
      errors.add(:selected_choices, 'Auswahl enthält ungültige Referenzen!')
    end
    
    # Check that all choices refer to same statement
    if selected_choices_inst.pluck(:statement_id).uniq.count > 1
      errors.add(:selected_choices, 'Auswahl enthält Referenzen auf unterschiedliche Statements!')
      return nil
    end

    return false
  end
end
