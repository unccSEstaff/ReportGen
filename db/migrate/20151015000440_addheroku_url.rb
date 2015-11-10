class AddherokuUrl < ActiveRecord::Migration
  def change
    add_column :students, :RailsTutorialHeroku, :string
  end
end
