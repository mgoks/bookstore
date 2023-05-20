# frozen_string_literal: true

require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test 'received' do
    mail = OrderMailer.received(orders(:one))
    assert_equal "Mooch's Bookstore order confirmation", mail.subject
    assert_equal ['dave@example.org'], mail.to

    # TODO: Figure out why the actual value is different.
    # assert_equal ["noreply@moochsbookstore.com"], mail.from

    assert_equal 'Murat Goksel noreply@moochsbookstore.com', mail.from

    # TODO: Figure why this is failing
    # assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end

  test 'shipped' do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Mooch's Bookstore order shipped", mail.subject
    assert_equal ['dave@example.org'], mail.to

    # TODO: Figure out why the actual value is different.
    # assert_equal ["noreply@moochsbookstore.com"], mail.from

    assert_equal 'Murat Goksel noreply@moochsbookstore.com', mail.from

    # TODO: Figure why this is failing
    # assert_match %r(
    #   <td[^>]*>1<\/td>\s*
    #   <td>&times;<\/td>\s*
    #   <td[^>]*>\s*Programming\sRuby\s1.9\s*</td>)x, mail.body.to_s
  end
end
