class Answer < ApplicationRecord
  belongs_to(:statement, dependent: :destroy)

  def selected_choices_inst
    selected_choices_ids = selected_choices.match(/\[(.*)\]/)[1].split(',')
    Choice.where(id: selected_choices_ids)
  end
end
