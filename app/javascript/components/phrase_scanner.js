export default {
  name: 'PhraseScanner',
  data() {
    return {
      input: '',
      loading: false,
      error: '',
      results: [],
      pollTimer: null,
      lang: 'es'
    }
  },
  computed: {
    t() {
      const es = {
        title: 'Brainwallet Rover',
        hint: 'Pega frases (una por línea). Se derivan direcciones brainwallet y se encola escaneo.',
        scan: 'Escanear',
        colPhrase: 'Frase',
        colStatus: 'Estado',
        colComp: 'Comp. Address',
        colUncomp: 'Uncomp. Address',
        colBalance: 'Balance BTC (confirmado)',
        colTxs: 'TXs',
        colEver: 'Alguna vez tuvo BTC',
        autoNote: 'La tabla se actualiza automáticamente cada 3s hasta completar.'
      }
      const en = {
        title: 'Brainwallet Rover',
        hint: 'Paste phrases (one per line). Brainwallet addresses will be derived and queued.',
        scan: 'Scan',
        colPhrase: 'Phrase',
        colStatus: 'Status',
        colComp: 'Comp. Address',
        colUncomp: 'Uncomp. Address',
        colBalance: 'BTC Balance (confirmed)',
        colTxs: 'TXs',
        colEver: 'Ever had BTC',
        autoNote: 'Table refreshes every 3s until finished.'
      }
      return this.lang === 'en' ? en : es
    }
  },
  mounted() {
    this.fetchRecent()
  },
  methods: {
    async fetchRecent() {
      try {
        const res = await fetch('/api/phrases?limit=50')
        if (!res.ok) return
        const json = await res.json()
        this.results = json.phrases || []
        if (this.results.some(r => r.status !== 'done')) this.startPolling()
      } catch (_) {}
    },
    async submit() {
      this.error = ''
      const lines = this.input.split('\n').map(l => l.trim()).filter(l => l.length > 0)
      if (lines.length === 0) {
        this.error = this.lang === 'en' ? 'Enter at least one phrase' : 'Ingresa al menos una frase'
        return
      }
      this.loading = true
      try {
        const res = await fetch('/api/phrases/bulk', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ contents: lines })
        })
        if (!res.ok) {
          const t = await res.text()
          throw new Error(t || 'Request failed')
        }
        const json = await res.json()
        const newRows = json.phrases || []
        this.mergeResults(newRows)
        // immediate refresh and fast polling
        await this.refreshStatuses()
        this.startPolling()
      } catch (e) {
        this.error = e.message
      } finally {
        this.loading = false
      }
    },
    mergeResults(newRows) {
      const currentById = new Map((this.results || []).map(r => [r.id, r]))
      const newIds = new Set(newRows.map(r => r.id))
      const mergedTop = newRows.map(n => {
        const existing = currentById.get(n.id)
        return existing ? Object.assign({}, existing, n) : n
      })
      const keepOld = (this.results || []).filter(r => !newIds.has(r.id))
      this.results = [...mergedTop, ...keepOld]
    },
    startPolling() {
      if (this.pollTimer) clearInterval(this.pollTimer)
      this.pollTimer = setInterval(this.refreshStatuses, 800)
    },
    async refreshStatuses() {
      const ids = (this.results || []).map(r => r.id)
      if (ids.length === 0) return
      try {
        const url = '/api/phrases?' + ids.map(id => `ids[]=${encodeURIComponent(id)}`).join('&')
        const res = await fetch(url)
        if (!res.ok) return
        const json = await res.json()
        const byId = new Map(json.phrases.map(p => [p.id, p]))
        this.results = this.results.map(r => byId.get(r.id) || r)
        const anyPending = this.results.some(r => r.status !== 'done')
        if (!anyPending && this.pollTimer) {
          clearInterval(this.pollTimer)
          this.pollTimer = null
        }
      } catch (_) { /* ignore transient errors */ }
    },
    formatBtc(sats) {
      if (sats == null) return '-'
      return (Number(sats) / 1e8).toFixed(8)
    },
    badgeClass(status) {
      if (status === 'done') return 'bg-green-100 text-green-800'
      if (status === 'processing') return 'bg-yellow-100 text-yellow-800'
      return 'bg-gray-100 text-gray-800'
    },
    anyEverFunded(row) {
      if (row.status !== 'done') return null
      const vals = (row.addresses || []).map(a => a.ever_had_btc).filter(v => v !== undefined)
      if (vals.length === 0) return null
      return vals.some(Boolean)
    }
  },
  template: `
    <div class="max-w-5xl mx-auto p-4">
      <div class="flex items-center justify-between">
        <h2 class="text-2xl font-bold mb-4">{{ t.title }}</h2>
        <div class="text-sm text-gray-600 mb-4 space-x-2">
          <button @click="lang='es'" :class="lang==='es' ? 'font-semibold text-indigo-700' : 'text-gray-600'">ES</button>
          <span>|</span>
          <button @click="lang='en'" :class="lang==='en' ? 'font-semibold text-indigo-700' : 'text-gray-600'">EN</button>
        </div>
      </div>
      <p class="text-sm text-gray-600 mb-2">{{ t.hint }}</p>
      <textarea v-model="input" rows="6" class="w-full border border-gray-300 rounded p-2 mb-3 focus:outline-none focus:ring-2 focus:ring-indigo-500" placeholder="correct horse battery staple\nmaytheforcebewithyou\n...\n"></textarea>
      <div class="flex items-center gap-2 mb-4">
        <button @click="submit" :disabled="loading" class="bg-indigo-600 text-white px-4 py-2 rounded disabled:opacity-50 hover:bg-indigo-700">{{ loading ? (lang==='en' ? 'Sending...' : 'Enviando...') : t.scan }}</button>
        <span v-if="error" class="text-red-600 text-sm">{{ error }}</span>
      </div>
      <div v-if="results.length > 0" class="overflow-x-auto">
        <table class="min-w-full bg-white border border-gray-200 rounded-lg overflow-hidden">
          <thead>
            <tr class="bg-gray-800 text-white text-left">
              <th class="px-3 py-2">{{ t.colPhrase }}</th>
              <th class="px-3 py-2">{{ t.colStatus }}</th>
              <th class="px-3 py-2">{{ t.colComp }}</th>
              <th class="px-3 py-2">{{ t.colUncomp }}</th>
              <th class="px-3 py-2">{{ t.colBalance }}</th>
              <th class="px-3 py-2">{{ t.colTxs }}</th>
              <th class="px-3 py-2">{{ t.colEver }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="r in results" :key="r.id" class="odd:bg-white even:bg-gray-50 text-gray-900">
              <td class="px-3 py-2 font-mono">{{ r.content }}</td>
              <td class="px-3 py-2">
                <span :class="'inline-flex px-2 py-0.5 text-xs rounded ' + badgeClass(r.status)">{{ r.status }}</span>
              </td>
              <td class="px-3 py-2 font-mono">{{ (r.addresses || []).find(a=>a.variant==='compressed')?.address || '-' }}</td>
              <td class="px-3 py-2 font-mono">{{ (r.addresses || []).find(a=>a.variant==='uncompressed')?.address || '-' }}</td>
              <td class="px-3 py-2">{{ formatBtc(((r.addresses||[])[0]?.confirmed_sats) || ((r.addresses||[])[1]?.confirmed_sats)) }}</td>
              <td class="px-3 py-2">{{ ((r.addresses||[])[0]?.tx_count) ?? ((r.addresses||[])[1]?.tx_count) ?? '-' }}</td>
              <td class="px-3 py-2">
                <template v-if="anyEverFunded(r) === null">-</template>
                <template v-else>{{ anyEverFunded(r) ? (lang==='en' ? 'Yes' : 'Sí') : (lang==='en' ? 'No' : 'No') }}</template>
              </td>
            </tr>
          </tbody>
        </table>
        <p class="text-sm text-gray-600 mt-2">{{ t.autoNote }}</p>
      </div>
    </div>
  `
}


