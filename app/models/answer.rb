class Answer < ApplicationRecord
  belongs_to(:statement, dependent: :destroy)

  validate :selected_choices_references

  def selected_choices_inst
    Choice.where(id: selected_choices_ids)
  end

  def selected_choices_ids
    selected_choices.match(/\[(.*)\]/)[1].split(',').map(&:to_i)
  end

  private

  def selected_choices_references
    has_choice_reference = selected_choices_ids.map { |id| Choice.where(id: id).any? }

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
