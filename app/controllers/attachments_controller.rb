class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if can?(:manage, attachment.record)
      attachment.purge
    else
      head :forbidden
    end
  end

  private

  helper_method :attachment

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
end
