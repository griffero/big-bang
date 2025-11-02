class ScanPhraseJob < ApplicationJob
  queue_as :default

  def perform(phrase_id)
    phrase = Phrase.find_by(id: phrase_id)
    return unless phrase

    phrase.update!(status: :processing)

    derivations = Brainwallet::DerivationService.derive_for_phrase(phrase.content)
    derivations.each do |d|
      address_record = Address.find_or_initialize_by(address: d.address)
      address_record.assign_attributes(
        phrase: phrase,
        variant: d.variant,
        wif: d.wif,
        hash160: d.hash160
      )
      address_record.save!

      stats = Balances::EsploraClient.fetch_address(d.address)
      next unless stats

      address_stat = AddressStat.find_or_initialize_by(address: address_record)
      address_stat.assign_attributes(
        confirmed_sats: stats[:confirmed_sats],
        unconfirmed_sats: stats[:unconfirmed_sats],
        tx_count: stats[:tx_count],
        last_seen_at: Time.current,
        source: 'esplora',
        raw_json: stats[:raw_json]
      )
      address_stat.save!
    end

    phrase.update!(status: :done, last_scanned_at: Time.current)
  rescue StandardError
    phrase.update(status: :pending) if phrase&.persisted?
    raise
  end
end


