class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @commentable = params[:commentable_type].constantize.find(params[commentable_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.assign_attributes(commentable: @commentable, user: current_user)

    flash[:notice] = 'Your comment successfully posted.' if @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])

    if can?(:manage, @comment)
      @comment.destroy
      flash[:notice] = 'Comment successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      'comments',
      {
        resource_name: @comment.commentable.class.name.downcase,
        resource_id: @comment.commentable.id,
        comment: @comment,
        author: @comment.user
      }.to_json
    )
  end

  def commentable_id
    "#{params[:commentable_type]}_id".downcase.to_sym
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
