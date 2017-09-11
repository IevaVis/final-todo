class BraintreeController < ApplicationController
  def new
  	@user = User.find(params[:id])
  	@client_token = Braintree::ClientToken.generate
  end

  def checkout
	  nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

	  result = Braintree::Transaction.sale(
	   :amount => "0.99",
	   :payment_method_nonce => nonce_from_the_client,
	   :options => {
	      :submit_for_settlement => true
	    }
	   )

	  if result.success?
	  	@user = User.find(params[:id])
	  	@user.update!(paid: true)
	  	redirect_to @user
	  end 
	end
end
