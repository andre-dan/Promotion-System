class PromotionMailer < ApplicationMailer::Base
    def approval_email
        @promotion = params[:promotion]
        mail(to: @promotion.user.email, subject: "A Promoção #{@promotion.name}, foi aprovada")
    end
end