#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require "bundler/setup"
require 'grpc'
require 'rpc_services_pb'

ENV['GRPC_SSL_CIPHER_SUITES'] = "HIGH+ECDSA"

certificate = File.read(File.expand_path("~/Library/Application Support/Lnd/tls.cert"))
credentials = GRPC::Core::ChannelCredentials.new(certificate)
stub = Lnrpc::Lightning::Stub.new('127.0.0.1:10009', credentials)

stub.subscribe_invoices(Lnrpc::InvoiceSubscription.new) do |invoice|
  puts invoice.inspect
end