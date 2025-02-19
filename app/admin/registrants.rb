ActiveAdmin.register Registrant do
permit_params :city, :address1, :address2, :belongs, :details, :email, :found, :job, :name, :number, :phone, :prefecture, :pronunciation

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :address1
    column :created_at
    actions
  end
  show do
  attributes_table do
    row :name
    row :pronunciation
    row :email
    row :phone
    row :created_at
    row :updated_at
  end
  active_admin_comments
  end
  form do |f|
  f.inputs "Registrant Details" do
    f.input :city
    f.input :address1
    f.input :address2
    f.input :belongs
    f.input :details
    f.input :email
    f.input :found
    f.input :job
    f.input :name
    f.input :number
    f.input :phone
    f.input :prefecture
    f.input :pronunciation
  end
  f.actions
  end
end
