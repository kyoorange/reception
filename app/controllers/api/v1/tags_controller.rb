module Api
  module V1
    class TagsController < ApplicationController
      def current_occupy
        # `number`でTagを検索
        tag = Tag.find_by(number: params[:tag_id])
        if tag.nil?
          Rails.logger.error("Tag not found for number: #{params[:tag_id]}")
          render json: { error: "Tag not found" }, status: :not_found
          return
        end

        # 最新の貸し出し状態を取得 (in_use のもののみ)
        current_occupy = tag.occupies.where(status: :in_use).order(created_at: :desc).first

        if current_occupy.nil?
          render json: { message: "No active occupy found for this tag" }, status: :not_found
        else
          render json: {
            id: current_occupy.id,
            status: current_occupy.status,
            created_at: current_occupy.created_at,
            registrant_name: current_occupy.registrant.name,
            registrant_number: current_occupy.registrant.number
          }, status: :ok
        end
      end
    end
  end
end
