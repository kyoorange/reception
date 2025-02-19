ActiveAdmin.register Occupy do
  permit_params :status, :time_length, :returned_at, :status, :registrant_id, :tag_id

  index do
    selectable_column
    id_column
    column :time_length
    column :returned_at
    column :status do |occupy|
      occupy.status
    end
    column :created_at
    column :updated_at
    column :registrant_id
    column :tag_id
    actions
  end

  filter :time_length
  filter :returned_at
  filter :created_at
  filter :updated_at
  filter :registrant_id
  filter :tag_id

  show do
    attributes_table do
      row :id
      row :time_length
      row :returned_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Occupy.statuses.keys
      f.input :time_length, label: "Time Length (minutes)"
      f.input :returned_at, as: :datetime_picker, label: "Returned At"
      f.input :registrant_id
      f.input :tag_id
    end
    f.actions
  end
end
