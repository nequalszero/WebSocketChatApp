# config/initializers/pusher.rb
require 'pusher'

Pusher.app_id = '331137'
Pusher.key = '62ce9c55c56e3b1a7fad'
Pusher.secret = '1b9d0e75d423e7202f14'
Pusher.logger = Rails.logger
Pusher.encrypted = true
