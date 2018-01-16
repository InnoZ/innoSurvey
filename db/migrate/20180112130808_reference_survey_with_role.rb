class ReferenceSurveyWithRole < ActiveRecord::Migration[5.1]
  def change
    add_reference :roles, :survey, foreign_key: true
  end
end
