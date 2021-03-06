class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: %i[generate_coupons show edit destroy update approve]
  before_action :can_be_approved, only: [:approve]

  def index
    @promotions = Promotion.all
  end

  def show; end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = current_user.promotions.new(promotion_params)
    if @promotion.save
      redirect_to @promotion, notice: t('.success')
    else
      render :new
    end
  end

  def edit; end

  def update
    return redirect_to @promotion, notice: t('.success') if @promotion.update(promotion_params)

    render :edit
  end

  def destroy
    if @promotion.destroy
      redirect_to promotions_path, notice: t('.exclude')
    else
      render :index
    end
  end

  def generate_coupons
    @promotion.generate_coupons!
    redirect_to @promotion, notice: t('.success')
  end

  def search
    @term = params[:q]
    @promotions = Promotion.search(@term)
  end

  def approve
    current_user.promotion_approvals.create!(promotion: @promotion)
    PromotionMailer.with(promotion: @promotion, user: @user).approval_email.deliver_now
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
  end

  private

  def set_promotion
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params
      .require(:promotion)
      .permit(:name, :expiration_date, :description,
              :discount_rate, :code, :coupon_quantity)
  end

  def can_be_approved
    unless @promotion.can_approve?(current_user)
      redirect_to @promotion,
                  alert: 'Ação não permitida'
    end
  end
end
