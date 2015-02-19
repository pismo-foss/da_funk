module Serfx
  # This class wraps the low level msgpack data transformation and tcp
  # communication for the RPC session. methods in this module are used to
  # implement the actual RPC commands available via [Commands]
  class Connection
    MAX_MESSAGE_SIZE = 1024
    DEFAULT_TIMEOUT  = 15
    COMMANDS = {
      handshake:        [:header],
      auth:             [:header],
      event:            [:header],
      force_leave:      [:header],
      join:             [:header, :body],
      members:          [:header, :body],
      members_filtered: [:header, :body],
      tags:             [:header],
      stream:           [:header],
      monitor:          [:header],
      stop:             [:header],
      leave:            [:header],
      query:            [:header],
      respond:          [:header],
      install_key:      [:header, :body],
      use_key:          [:header, :body],
      remove_key:       [:header, :body],
      list_keys:        [:header, :body],
      stats:            [:header, :body]
    }

    include Serfx::Commands

    attr_reader :host, :port, :seq, :socket, :socket_tcp, :socket_block, :timeout

    def close
      @socket_tcp.close
      @socket.close
    end

    def closed?
      @socket_tcp.closed?
    end

    # @param  opts [Hash] Specify the RPC connection details
    # @option opts [TCPSocket] :socket_tcp Socket
    # @option opts [SSL] :socket Socket SSL or normal tcp socket
    # @option opts [Fixnum] :timeout Timeout in seconds to wait for a event and return Fiber
    # @option opts [Symbol] :authkey encryption key for RPC communication
    # @option opts [Block] :socket_block Callback to create socket if socket was closed, should return [socket, socket_tcp]
    def initialize(opts = {})
      if @socket_block = opts[:socket_block]
        @socket, @socket_tcp = @socket_block.call
      else
        @socket = opts[:socket]
        @socket_tcp = opts[:socket_tcp]
      end
      @timeout = opts[:timeout] || DEFAULT_TIMEOUT
      @seq = 0
      @authkey = opts[:authkey]
      @requests = {}
      @responses = {}
    end

    # read data from tcp socket and pipe it through msgpack unpacker for
    # deserialization
    #
    # @return [Hash]
    def read_data
      p "1===="
      p buf = socket.recv(MAX_MESSAGE_SIZE, Socket::MSG_PEEK)
      p "2===="
      #if not socket.recv(MAX_MESSAGE_SIZE, Socket::MSG_PEEK).empty?
        #buf = socket.recv(MAX_MESSAGE_SIZE)
      #end
      p "3===="
      first_packet, second_packet = buf.split("\x85")

      if second_packet.nil?
        [MessagePack.unpack(first_packet), nil]
      else
        [MessagePack.unpack(first_packet), MessagePack.unpack("\x85" + second_packet)]
      end
    end

    # takes raw RPC command name and an optional request body
    # and convert them to msgpack encoded data and then send
    # over tcp
    #
    # @param command [String] RPC command name
    # @param body [Hash] request body of the RPC command
    #
    # @return [Integer]
    def tcp_send(command, body = nil)
      @seq += 1
      header = {
        'Command' => command.to_s.gsub('_', '-'),
        'Seq' => seq
      }
      buff = MessagePack::Packer.new
      buff.write(header)
      buff.write(body) unless body.nil?
      res = socket.write(buff.to_str)
      @requests[seq] = { header: header, ack?: false }
      seq
    end

    # checks if the RPC response header has `error` field popular or not
    # raises [RPCError] exception if error string is not empty
    #
    # @param header [Hash] RPC response header as hash
    def check_rpc_error!(header)
      if header
        raise RPCError, header['Error'] unless header['Error'].empty?
      end
    end

    # read data from the tcp socket. and convert it to a [Response] object
    #
    # @param command [String] RPC command name for which response will be read
    # @return [Response]
    def read_response(command)
      header, body = read_data
      check_rpc_error!(header)
      if COMMANDS[command].include?(:body)
        Response.new(header, body)
      else
        Response.new(header)
      end
    end

    # make an RPC request against the serf agent
    #
    # @param command [String] name of the RPC command
    # @param body [Hash] an optional request body for the RPC command
    # @return [Response]
    def request(command, body = nil)
      tcp_send(command, body)
      read_response(command)
    end
  end
end

