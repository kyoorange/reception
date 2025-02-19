module Api
  module V1
    class RegistrantsController < ApplicationController
      # APIではCSRFトークンの検証をスキップ
      protect_from_forgery with: :null_session

      # 全てのregistrantsを返す
      def index
        registrants = Registrant.all
        render json: registrants
      end

      # numberで指定したregistrantを返す
      def show
        # `number`を使って検索
        registrant = Registrant.find_by(number: params[:id])

        if registrant
          render json: registrant
        else
          render json: { error: "Registrant not found" }, status: :not_found
        end
      end

      def find_by_phone
        standardized_phone = params[:phone].tr("０-９", "0-9").gsub(/[-\s]/, "") # 全角→半角、ハイフンとスペースを除去
        registrant = Registrant.find_by("REPLACE(REPLACE(phone, '-', ''), ' ', '') = ?", standardized_phone)
        if registrant
          render json: registrant
        else
          render json: { error: "Registrant not found" }, status: :not_found
        end
      end

      # 新しいregistrantを作成
      def create
        registrant = Registrant.new(registrant_params)
        if registrant.save
          render json: registrant, status: :created
        else
          render json: { errors: registrant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # 指定したregistrantを更新
      def update
        registrant = Registrant.find_by(number: params[:id])
        if registrant&.update(registrant_params)
          render json: registrant
        else
          render json: { errors: registrant.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # 指定したregistrantを削除
      def destroy
        registrant = Registrant.find_by(number: params[:id])
        if registrant
          registrant.destroy
          render json: { message: "Registrant record deleted" }, status: :ok
        else
          render json: { error: "Registrant not found" }, status: :not_found
        end
      end

      private

      # Strong Parametersを設定
      def registrant_params
        params.require(:registrant).permit(:name, :number)
      end
    end
  end
end
