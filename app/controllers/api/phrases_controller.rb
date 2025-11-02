module Api
  class PhrasesController < ApplicationController
    skip_forgery_protection

    def index
      ids = Array(params[:ids]).map(&:to_i).uniq.compact
      if ids.present?
        phrases = Phrase.where(id: ids).includes(addresses: :address_stat)
      else
        limit = params[:limit].to_i
        limit = 50 if limit <= 0
        limit = 200 if limit > 200
        phrases = Phrase.order(created_at: :desc).limit(limit).includes(addresses: :address_stat)
      end
      render json: { phrases: phrases.map { |p| serialize_phrase(p) } }
    end

    def create
      content = normalize(params[:content].to_s)
      if content.blank?
        return render json: { error: 'content required' }, status: :unprocessable_entity
      end

      phrase = Phrase.find_or_create_by!(content: content)
      ScanPhraseJob.perform_later(phrase.id)
      render json: { id: phrase.id, content: phrase.content, status: phrase.status }
    end

    def bulk
      contents = params[:contents]
      unless contents.is_a?(Array)
        return render json: { error: 'contents must be an array' }, status: :unprocessable_entity
      end

      results = []
      contents.each do |c|
        normalized = normalize(c.to_s)
        next if normalized.blank?

        phrase = Phrase.find_or_create_by!(content: normalized)
        ScanPhraseJob.perform_later(phrase.id)
        results << serialize_phrase(phrase)
      end

      render json: { phrases: results }
    end

    private

    def normalize(text)
      text.strip.downcase
    end

    def serialize_phrase(phrase)
      {
        id: phrase.id,
        content: phrase.content,
        status: phrase.status,
        last_scanned_at: phrase.last_scanned_at,
        addresses: phrase.addresses.map do |a|
          stat = a.address_stat
          raw = stat&.raw_json || {}
          chain_funded = raw.dig('chain_stats', 'funded_txo_sum').to_i
          mem_funded = raw.dig('mempool_stats', 'funded_txo_sum').to_i
          ever_had_btc = (chain_funded + mem_funded) > 0 || (stat&.tx_count.to_i > 0)
          {
            id: a.id,
            variant: a.variant,
            address: a.address,
            confirmed_sats: stat&.confirmed_sats,
            unconfirmed_sats: stat&.unconfirmed_sats,
            tx_count: stat&.tx_count,
            ever_had_btc: ever_had_btc
          }
        end
      }
    end
  end
end


