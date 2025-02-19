class TransfersController < ApplicationController
  def index
    @transfers = Transfer.all
  end

  def create
    @transfer = Transfer.new(transfer_params)
    if @transfer.save
      # 作成されたTransferをJSON形式で返す
      render json: { transfer: @transfer, status: :created }
    else
      render json: { errors: @transfer.errors.full_messages, status: :unprocessable_entity }
    end
  end

  private

  def transfer_params
    # authorとdetailが必須パラメータとして設定されていることを確認
    params.require(:transfer).permit(:author, :detail)
  end
end
