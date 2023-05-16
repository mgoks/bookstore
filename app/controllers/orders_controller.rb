# frozen_string_literal: true

class OrdersController < ApplicationController
  include CurrentCart

  # Executed in order.
  before_action :set_cart, only: %i[new create]
  before_action :ensure_cart_isnt_empty, only: %i[new]
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show; end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_form_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html do
          redirect_to store_index_url, notice: 'Thank you for your order.'
        end
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @order.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html do
          redirect_to order_url(@order),
                      notice: 'Order was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @order.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html do
        redirect_to orders_url, notice: 'Order was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:name, :address, :email, :pay_type)
  end

  def ensure_cart_isnt_empty
    return unless @cart.line_items.empty?

    redirect_to store_index_url, notice: 'Your cart is empty.'
  end
end
