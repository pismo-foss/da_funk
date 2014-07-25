require '../lib/iso8583'
require 'socket'
require 'date'

module Guide
    class TransactMessage < Device::Transaction::Iso
        mti_format AN, :length => 4

        # MTI
        mti "0100",  "Authorization request"
        mti "0110",  "Issuer Response"
        mti "0120",  "Authorization Advice"
        mti "0121",  "Authorisation Advice Repeat"
        mti "0130",  "Issuer Response to Authorization Advice"
        mti "0200",  "Acquirer Financial Request"
        mti "0210",  "Issuer Response to Financial Request"
        mti "0220",  "Acquirer Financial Advice"
        mti "0221",  "Acquirer Financial Advice repeat"
        mti "0230",  "Issuer Response to Financial Advice"
        mti "0320",  "Batch Upload"
        mti "0330",  "Batch Upload Response"
        mti "0400",  "Acquirer Reversal Request"
        mti "0420",  "Acquirer Reversal Advice"
        mti "0421",  "Acquirer Reversal Advice Repeat Message"
        mti "0430",  "Issuer Reversal Response"
        mti "0500",  "Batch Settlement request"
        mti "0510",  "Batch Settlement response"
        mti "0800",  "Network Management Request"
        mti "0810",  "Network Management Response"
        mti "0820",  "Network Management Advice"

        # ISO-defined data elements
        bmp 2,  "Primary Account Number (PAN)",               LLVAR_N,    :max    => 19
        bmp 3,  "Processing Code",                            N,          :length => 6
        bmp 4,  "Amount (Transaction)",                       N,          :length => 12
        bmp 5,  "Amount, settlement" ,                        N,          :length => 12
        bmp 6,  "Amount, Cardholder Billing" ,                N,          :length => 12
        bmp 7,  "Date and Time, Transmission"  ,              MMDDhhmmss
        bmp 8,  "Amount, cardholder billing fee" ,            N,          :length => 8
        bmp 9,  "Conversion rate, settlement" ,               N,          :length => 8
        bmp 10, "Conversion Rate, Cardholder Billing",        N,          :length => 8
        bmp 11, "System Trace Audit Number (STAN)",           ANS,        :length => 6
        bmp 12, "Time, local transaction (hhmmss)",           Hhmmss
        bmp 13, "Date, local transaction (MMDD)",             MMDD
        bmp 14, "Date, Expiration",                           N,          :length => 4
        bmp 15, "Date, Expiration",                           N,          :length => 4
        bmp 16, "Date, conversion",                           N,          :length => 4
        bmp 17, "Date, capture",                              N,          :length => 4
        bmp 18, "Merchant type",                              N,          :length => 4
        bmp 19, "Acquiring institution country code",         N,          :length => 3
        bmp 20, "PAN extended, country code",                 N,          :length => 3
        bmp 21, "Forwarding institution. country code",       N,          :length => 3
        bmp 22, "POS Data Code",                              AN,         :length => 12
        bmp 23, "Card Sequence Number",                       N,          :length => 3
        bmp 24, "Function Code",                              N,          :length => 3
        bmp 25, "Message Reason Code",                        N,          :length => 4
        bmp 26, "Card Acceptor Business Code",                N,          :length => 4
        bmp 27, "Authorizing identification response length", N,          :length => 1
        bmp 28, "Amount, transaction fee",                    N,          :length => 8
        bmp 29, "Amount, settlement fee",                     N,          :length => 8
        bmp 30, "Amount, transaction processing fee",         N,          :length => 8
        bmp 31, "Amount, settlement processing fee",          N,          :length => 8
        bmp 32, "Acquiring Institution Identification Code",  LLVAR_N,    :max    => 11
        bmp 33, "Forwarding institution identification code", LLVAR_N,    :max    => 11
        bmp 34, "Primary account number, extended",           LLVAR_N,    :max    => 28
        bmp 35, "Track 2 Data",                               LLVAR_Z,    :max    => 37
        bmp 36, "Track 3 Data",                               LLVAR_N,    :max    => 104
        bmp 37, "Retrieval Reference Number",                 ANP,        :length => 12
        bmp 38, "Approval Code",                              ANP,        :length => 6
        bmp 39, "Action Code",                                N,          :length => 2
        bmp 40, "Action Code",                                AN,         :length => 3
        bmp 41, "Card Acceptor Terminal Identification",      ANS,        :length => 8
        bmp 42, "Card Acceptor Identification Code",          ANS,        :length => 15
        bmp 43, "Card Acceptor Name/Location",                ANS,        :length => 40
        bmp 44, "Additional response data",                   LLVAR_AN,   :max    => 25
        bmp 45, "Track 1 data",                               LLVAR_AN,   :max    => 76
        bmp 46, "Additional data - private",                  LLVAR_AN,   :max    => 999
        bmp 47, "Additional data - private",                  LLVAR_AN,   :max    => 999
        bmp 48, "Additional data - private",                  LLLVAR_AN,  :max    => 22
        bmp 49, "Currency Code, Transaction",                 N,          :length => 3
        bmp 50, "Currency Code, Settlement",                  N,          :length => 3
        bmp 51, "Currency Code, Cardholder Billing",          N,          :length => 3
        bmp 52, "Personal Identification Number (PIN) Data",  B,          :length => 8
        bmp 53, "Security Related Control Information",       N,          :length => 16
        bmp 54, "Amounts, Additional",                        LLLVAR_ANS, :max    => 120
        bmp 55, "Integrated Circuit Card (ICC)",              LLLVAR_B,   :max    => 255
        bmp 56, "Original Data Elements",                     LLVAR_N,    :max    => 35
        bmp 57, "Reserved national",                          LLLVAR_ANS, :max    => 999
        bmp 58, "Authorizing Agent Institution ID Code",      LLVAR_N,    :max    => 11
        bmp 59, "Additional Data - Private",                  LLLVAR_ANS, :max    => 67
        bmp 60, "Reserved national",                          LLLVAR_N,   :max    => 999
        bmp 61, "Reserved private",                           LLLVAR_ANS, :max    => 999
        bmp 62, "Reserved private",                           LLLVAR_ANS, :max    => 999
        bmp 63, "Additional Data - Private",                  LLLVAR_ANS, :max    => 67
        bmp 64, "Message Authentication Code (MAC) Field",    B,          :length => 8
        bmp 65, "Bitmap, extended",                           N,          :length => 1
        bmp 66, "Settlement code",                            N,          :length => 1
        bmp 67, "Extended payment code",                      N,          :length => 2
        bmp 68, "Receiving institution country code",         N,          :length => 3
        bmp 69, "Settlement institution country code",        N,          :length => 3
        bmp 70, "Network management information code",        AN,          :length => 3
        bmp 71, "Message number",                             N,          :length => 4
        bmp 72, "Message number, last",                       N,          :length => 4
        bmp 73, "Date, action (YYMMDD)",                      YYMMDD
        bmp 74, "Credits, number",                            N,          :length => 10
        bmp 75, "Credits, reversal number",                   N,          :length => 10
        bmp 76, "Debits, number",                             N,          :length => 10
        bmp 77, "Debits, reversal number",                    N,          :length => 10
        bmp 78, "Transfer number",                            N,          :length => 10
        bmp 79, "Transfer, reversal number",                  N,          :length => 10
        bmp 80, "Inquiries number",                           N,          :length => 10
        bmp 81, "Authorizations, number",                     N,          :length => 10
        bmp 82, "Credits, processing fee amount",             N,          :length => 12
        bmp 83, "Credits, transaction fee amount",            N,          :length => 12
        bmp 84, "Debits, processing fee amount",              N,          :length => 12
        bmp 85, "Debits, transaction fee amount",             N,          :length => 12
        bmp 86, "Credits, amount",                            N,          :length => 16
        bmp 87, "Credits, reversal amount",                   N,          :length => 16
        bmp 88, "Debits, amount",                             N,          :length => 16
        bmp 89, "Debits, reversal amount",                    N,          :length => 16
        bmp 90, "Original data elements",                     N,          :length => 42
        bmp 91, "File update code",                           AN,         :length => 1
        bmp 92, "File security code",                         AN,         :length => 2
        bmp 93, "Response indicator",                         AN,         :length => 5
        bmp 94, "Service indicator",                          AN,         :length => 7
        bmp 95, "Replacement amounts",                        AN,         :length => 42
        bmp 96, "Message security code",                      B,          :length => 8
        bmp 97, "Amount, net settlement",                     AN,         :length => 16
        bmp 98, "Payee",                                      ANS,        :length => 25
        bmp 99, "Settlement institution identification code", LLVAR_N,    :max    => 11
        bmp 100, "Receiving institution identification code", LLVAR_N,    :max    => 11
        bmp 101, "File name",                                 LLVAR_ANS,  :max    => 17
        bmp 102, "Account identification 1",                  LLVAR_ANS,  :max    => 28
        bmp 103, "Account identification 2",                  LLVAR_ANS,  :max    => 28
        bmp 104, "Transaction description",                   LLLVAR_ANS, :max    => 100
        bmp 105, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 106, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 107, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 108, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 109, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 110, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 111, "Reserved for ISO use",                      LLLVAR_ANS, :max    => 999
        bmp 112, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 113, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 114, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 115, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 116, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 117, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 118, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 119, "Reserved for national use",                 LLLVAR_ANS, :max    => 999
        bmp 120, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 121, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 122, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 123, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 124, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 125, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 126, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 127, "Reserved for private use",                  LLLVAR_ANS, :max    => 999
        bmp 128, "Message authentication code",               B,          :length => 64

        def self.send_message (iso8583message)
          serial_terminal = "0000115030462365"

          puts "TCP #{(socket = TCPSocket.new('switch.cloudwalk.io', 31415)).inspect}"

          handshake = "#{serial_terminal};maxtraprivatelabel.posxml;0002;3.64"

          socket.write handshake.insert(0, handshake.size.chr)
          @message = socket.read(3)

          puts "Company Name #{@message}"

          if (@message != "err" && @message)
            msgSend = iso8583message.to_b
            socket.write(msgSend)
            
            # Receive message length
            msg = socket.recv(2)

            # Receive message
            buf = socket.recv(msg.unpack("s>").first)
          end

          socket.close

          return buf
        end

        def self.call
            # Create ISO8583 message and set fields
            date_time = DateTime.now
            message = self.new

            message.mti = "0800"                             # MTI
            message[7]  = date_time.strftime "%m%d%H%M%S"    # Bit 7
            message[11] = "000023"                           # Bit 11
            message[12] = date_time.strftime "%H%M%S"        # Bit 12
            message[13] = date_time.strftime "%m%d"          # Bit 13
            message[41] = "00000002"                         # Bit 41
            message[42] = "72010003"                         # Bit 42
            message[60] = "09"                               # Bit 60
            message[61] = "APPKS"                            # Bit 61
            message[70] = "001"                              # Bit 70

            # Print ISO8583 Message
            puts "Message ISO8583: " + message.to_b
            puts "=" * 100
            puts message.to_s

            # Try send ISO8583 Message
            puts "=" * 100
            bufRecv = self.send_send(message)
            # bufRecv = "08008238000000C000180400000000000000071103041000002303041007110000000272010003       00209005APPKS001"
            puts "Buffer Received: " + bufRecv

            # Parse message
            msgRecv = self.parse bufRecv
            puts "=" * 100
            p msgRecv
        end
    end
end     