#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))
require "bundler/setup"
require 'grpc'
require 'rpc_services_pb'

# Due to updated ECDSA generated tls.cert we need to let gprc know that
# we need to use that cipher suite otherwise there will be a handhsake
# error when we communicate with the lnd rpc server.
ENV['GRPC_SSL_CIPHER_SUITES'] = "HIGH+ECDSA"

certificate = File.read(File.expand_path("~/Library/Application Support/Lnd/tls.cert"))
credentials = GRPC::Core::ChannelCredentials.new(certificate)
stub = Lnrpc::Lightning::Stub.new('127.0.0.1:10009', credentials)

response = stub.wallet_balance(Lnrpc::WalletBalanceRequest.new())
puts "Total balance: #{response.total_balance}"