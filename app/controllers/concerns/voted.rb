module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable
  end

  def vote_up
    @votable.vote_up(current_user)

    render_json
  end

  def vote_down
    @votable.vote_down(current_user)

    render_json
  end

  def cancel_vote
    @votable.cancel_vote(current_user)

    render_json
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id]) rescue nil
  end

  def model_klass
    controller_name.classify.constantize
  end

  def render_json
    render json: {
      id: @votable.id,
      type: @votable.class.to_s,
      rating: @votable.rating
    }
  end
end
