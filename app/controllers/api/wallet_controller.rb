class API::WalletController < API::ApiController
  before_action :authenticate_user!

  def by_user
    @wallet = Wallet.find_by(user_id: params[:user_id])
    authorize @wallet
    render :show
  end

  def transactions
    @wallet = Wallet.find(params[:id])
    authorize @wallet
    @wallet_transactions = @wallet.wallet_transactions.includes(:invoice, user: [:profile]).order(created_at: :desc)
  end

  def credit
    @wallet = Wallet.find(params[:id])
    authorize @wallet
    service = WalletService.new(user: current_user, wallet: @wallet)
    if service.credit(params[:amount].to_f)
      render :show
    else
      head 422
    end
  end
end
