require 'json'
require 'pusher'

class Api::V1::ChatController < ApplicationController

  def create

    chat_json = JSON.parse(request.body.read)
    chat = Chat.new(
      username: chat_json['username'],
      message: chat_json['message']
    )

    if chat.save
      pusher = Pusher::Client.new(
        app_id: ENV['pusher_app_id'],
        key: ENV['pusher_key'],
        secret: ENV['pusher_secret'],
        cluster: ENV['pusher_cluster'],
        use_tls: ENV['pusher_encrypted']
      )

      pusher.trigger('chetapp', 'messages', {
        username: chat_json['username'],
        message: chat_json['message']
      })
      render json: chat, status:201
    else
      render json: {
        error: "cannot send messages", status:400
      }
    end
  end

  def show
    chats = Chat.order('created_at DESC').limit(50).reverse
    render json: chats, status:200
  end
end
