class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :niner_net
      t.string :codecademy

      t.timestamps
    end
  end
end
