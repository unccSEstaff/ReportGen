class Canvas < ActiveRecord::Migration
  def change
     add_column :students, :section, :string
     add_column :students, :SISid, :string
     add_column :students, :canvasID, :string
  end
end
