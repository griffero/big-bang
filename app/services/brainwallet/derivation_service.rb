require 'digest'
require 'openssl'
require 'digest/rmd160'

module Brainwallet
  class DerivationService
    BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'.freeze

    Derivation = Struct.new(
      :variant,
      :address,
      :wif,
      :hash160,
      :pubkey_hex,
      keyword_init: true
    )

    def self.derive_for_phrase(phrase)
      priv_key_bytes = sha256_bytes(phrase.to_s)
      return [] unless valid_private_key?(priv_key_bytes)

      pub_uncompressed = derive_public_key(priv_key_bytes, compressed: false)
      pub_compressed = derive_public_key(priv_key_bytes, compressed: true)

      res_uncompressed = build_result(priv_key_bytes, pub_uncompressed, :uncompressed)
      res_compressed = build_result(priv_key_bytes, pub_compressed, :compressed)

      [res_compressed, res_uncompressed]
    end

    def self.build_result(priv_key_bytes, pubkey_bytes, variant)
      pubkey_hash160 = hash160(pubkey_bytes)
      address = base58check(0x00.chr + pubkey_hash160)
      wif_payload = 0x80.chr + priv_key_bytes + (variant == :compressed ? 0x01.chr : '')
      wif = base58check(wif_payload)

      Derivation.new(
        variant: variant,
        address: address,
        wif: wif,
        hash160: pubkey_hash160.unpack1('H*'),
        pubkey_hex: pubkey_bytes.unpack1('H*')
      )
    end

    def self.sha256_bytes(data)
      Digest::SHA256.digest(data)
    end

    def self.hash160(data)
      sha = Digest::SHA256.digest(data)
      Digest::RMD160.digest(sha)
    end

    def self.base58check(payload)
      checksum = Digest::SHA256.digest(Digest::SHA256.digest(payload))[0, 4]
      base58_encode(payload + checksum)
    end

    def self.base58_encode(bytes)
      int_val = bytes.unpack1('H*').to_i(16)
      result = +''
      while int_val > 0
        int_val, remainder = int_val.divmod(58)
        result << BASE58_ALPHABET[remainder]
      end
      # Deal with leading zeros
      bytes.each_byte.take_while { |b| b == 0 }.count.times { result << BASE58_ALPHABET[0] }
      result.reverse
    end

    def self.derive_public_key(priv_key_bytes, compressed: true)
      group = OpenSSL::PKey::EC::Group.new('secp256k1')
      priv_bn = OpenSSL::BN.new(priv_key_bytes.unpack1('H*'), 16)
      pub_point = group.generator.mul(priv_bn)
      form = compressed ? :compressed : :uncompressed
      pub_point.to_octet_string(form)
    end

    def self.valid_private_key?(priv_key_bytes)
      n_hex = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141'
      n = OpenSSL::BN.new(n_hex, 16)
      x = OpenSSL::BN.new(priv_key_bytes.unpack1('H*'), 16)
      x > 0 && x < n
    end
  end
end


