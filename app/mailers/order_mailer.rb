# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  default from: 'Mooch\'s Bookstore <noreply@moochsbookstore.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order
    mail to: order.email, subject: "Mooch's Bookstore order confirmation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order
    mail to: order.email, subject: "Mooch's Bookstore order shipped"
  end

  def ship_date_updated(order)
    @order = order
    mail to: order.mail, subject: "Mooch's Bookstore order shipping date
                                  updated"
  end
end
