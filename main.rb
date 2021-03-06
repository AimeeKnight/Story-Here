require 'rubygems'
require 'json'
require 'net/http'
require 'sinatra'
require 'sinatra/flash'
require 'prawn'
require 'prawn/qrcode'
require './env' if File.exists?('env.rb')
enable :sessions

get '/' do  
	erb :index
end  

post '/' do
	qrcode_content = params[:url].to_s
	if valid_url qrcode_content
		qrcode = RQRCode::QRCode.new(qrcode_content, :level=>:h, :size => 5, :extend=> 72)

		# Render a prepared QRCode at he cursor position
		# using a default module (e.g. dot) size of 1pt or 1/72 in
		@pdf = Prawn::Document::new do
		  render_qr_code(qrcode)
		  render_file("qr1.pdf")
		end		
		content_type 'application/pdf'
		@pdf.render
	else
		flash.now[:error] = "Please enter a valid URL."
		erb :index
	end
end

def valid_url url
	url =~ /https?:\/\/[\S]+/
end