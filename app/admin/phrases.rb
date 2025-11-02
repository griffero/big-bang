ActiveAdmin.register Phrase do
  permit_params :content, :status

  actions :all

  index do
    selectable_column
    id_column
    column :content
    column :status
    column :last_scanned_at
    column :created_at
    actions
  end

  filter :content
  filter :status
  filter :last_scanned_at

  form do |f|
    f.inputs do
      f.input :content
    end
    f.actions
  end

  after_create do |phrase|
    ScanPhraseJob.perform_later(phrase.id)
  end
end


