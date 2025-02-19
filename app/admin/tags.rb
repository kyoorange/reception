ActiveAdmin.register Tag do
  permit_params :number, :name

  index do
      selectable_column
      id_column
      column :number
      column :name
      actions
  end
  show do
    attributes_table do
      row :id
      row :number
      row :name
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :number
      f.input :name
    end
    f.actions
  end
end
