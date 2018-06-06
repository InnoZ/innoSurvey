# derived from https://gist.github.com/wteuber/5318013
######################################################

require 'openssl'

class String
  def encrypt(key: 'ratzEncryptTheInnoZ')
    cipher = OpenSSL::Cipher.new('AES-256-CBC').encrypt
    # must be 32 bytes:
    cipher.key = Digest::SHA256.digest(key)
    s = cipher.update(self) + cipher.final
    s.unpack('H*')[0].upcase
  end

  def decrypt(key: 'ratzEncryptTheInnoZ')
    cipher = OpenSSL::Cipher.new('AES-256-CBC').decrypt
    # must be 32 bytes:
    cipher.key = Digest::SHA256.digest(key)
    s = [self].pack("H*").unpack("C*").pack("c*")
    cipher.update(s) + cipher.final
  end
end
