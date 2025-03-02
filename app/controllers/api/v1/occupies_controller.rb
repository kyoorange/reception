module Api
  module V1
    class OccupiesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        occupies = Occupy.where(status: params[:status]).page(params[:page]).per(params[:per_page])
        render json: occupies
      end

      def show
      occupy = Occupy.find_by(tag_id: params[:tag_id])
        if occupy
          # expires_now
          render json: occupy
        else
          head :not_found
        end
      end

      def occupy_status
        # Occupyテーブルから状態を取得し、Tag情報と結合
        occupies = Occupy.joins(:tag)
                        .select("tags.number AS room_number, occupies.status AS status")
                        .where(status: [ :in_use, :returned, :canceled ]) # 必要な状態を指定
        render json: occupies # JSONでレスポンスを返す
      end

      # Occupyレコードを新規作成する
      def create
        Rails.logger.debug("Received registrant_id: #{occupy_params[:registrant_id]}")
        Rails.logger.debug("Received tag_id: #{occupy_params[:tag_id]}")

        registrant = Registrant.find_by(number: occupy_params[:registrant_id])
        tag = Tag.find_by(number: occupy_params[:tag_id])

        if registrant && tag
          # Occupyインスタンスを作成し、`status` を in_use に設定
          occupy = Occupy.new(
            registrant_id: registrant.id,
            tag_id: tag.id,
            time_length: occupy_params[:time_length],
            returned_at: occupy_params[:returned_at],
            status: :in_use # 明示的にステータスを設定
          )

          if occupy.save
            render json: occupy, status: :created # HTTPステータスコードは201 (Created)
          else
            Rails.logger.error("Occupy creation failed: #{occupy.errors.full_messages}")
            render json: { errors: occupy.errors.full_messages }, status: :unprocessable_entity
          end
        else
          # 見つからない場合のエラーメッセージをログとレスポンスに表示
          missing = []
          missing << "Registrant" unless registrant
          missing << "Tag" unless tag
          Rails.logger.error("#{missing.join(' and ')} not found")
          render json: { error: "#{missing.join(' and ')} not found" }, status: :not_found
        end
      end

      # Occupyレコードを更新する
      def update
        occupy = Occupy.find(params[:id])
        if occupy.update(occupy_params.merge(status: :returned))
          expires_now
          render json: occupy.reload # 最新データを返却
        else
          render json: { errors: occupy.errors.full_messages }, status: :unprocessable_entity
        end
      end
      # Occupyレコードを削除する
      def destroy
        occupy = Occupy.find(params[:id])
        occupy.destroy
        render json: { message: "Occupy record deleted" }, status: :ok
      end

      def all_room_statuses
        occupies = Occupy.joins(:tag)
                        .select("tags.number AS room_number, occupies.status")
                        .where(status: :in_use)
                        .order("tags.number")
        
        # 結果をハッシュマップに変換
        result = {}
        occupies.each do |occupy|
          result[occupy.room_number.to_i] = occupy.status
        end
        
        render json: result
      end

      private

      # Strong Parametersを定義
      def occupy_params
        params.require(:occupy).permit(:time_length, :returned_at, :registrant_id, :tag_id, :status)
      end
    end
  end
end
