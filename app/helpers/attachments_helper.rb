module AttachmentsHelper
  def delete_link(resource, attachment)
    resource.files.find(attachment.id).purge
  end
end
