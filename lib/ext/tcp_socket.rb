class TCPSocket
  def bytes_available
    recv(0, Socket::MSG_PEEK).to_s.size
  end
end

