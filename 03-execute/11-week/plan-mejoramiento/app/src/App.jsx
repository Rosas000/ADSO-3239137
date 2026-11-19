import React, { useEffect, useState } from 'react'
import { request, setToken, getToken } from './api.js'

export default function App() {
  const [logged, setLogged] = useState(!!getToken())
  const [email, setEmail] = useState('asesor@eventfurniture.co')
  const [password, setPassword] = useState('secreto')
  const [msg, setMsg] = useState('')
  const [articles, setArticles] = useState([])
  const [organizers, setOrganizers] = useState([])
  const [organizerId, setOrganizerId] = useState('')
  const [articleId, setArticleId] = useState('')
  const [quantity, setQuantity] = useState(1)

  async function login(e) {
    e.preventDefault()
    const { status, data } = await request('POST', '/auth/login', { email, password })
    if (status === 200) {
      setToken(data.token)
      setLogged(true)
      setMsg('')
    } else {
      setMsg(data?.message || 'No se pudo iniciar sesión.')
    }
  }

  async function load() {
    const a = await request('GET', '/articles')
    const o = await request('GET', '/organizers')
    setArticles(a.data?.data || [])
    setOrganizers(o.data?.data || [])
  }

  useEffect(() => { if (logged) load() }, [logged])

  async function createRental(e) {
    e.preventDefault()
    const { status, data } = await request('POST', '/rentals', {
      organizer_id: Number(organizerId),
      lines: [{ article_id: Number(articleId), quantity: Number(quantity) }],
    })
    setMsg(status === 201 ? 'Alquiler creado correctamente.' : (data?.message || 'Error al crear el alquiler.'))
    if (status === 201) load()
  }

  if (!logged) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <form onSubmit={login} className="bg-white p-8 rounded-lg shadow w-80 space-y-4">
          <h1 className="text-xl font-bold text-gray-800">Event Furniture</h1>
          <input className="w-full border rounded p-2" value={email} onChange={e => setEmail(e.target.value)} placeholder="Correo" />
          <input className="w-full border rounded p-2" type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="Contraseña" />
          <button className="w-full bg-blue-600 text-white rounded p-2">Iniciar sesión</button>
          {msg && <p className="text-red-600 text-sm">{msg}</p>}
        </form>
      </div>
    )
  }

  return (
    <div className="max-w-3xl mx-auto p-6 space-y-8">
      <h1 className="text-2xl font-bold text-gray-800">Event Furniture — Aplicación</h1>
      {msg && <p className="text-sm text-blue-700">{msg}</p>}

      <section>
        <h2 className="text-lg font-semibold mb-2">Catálogo</h2>
        <ul className="space-y-1">
          {articles.map(a => (
            <li key={a.id} className="border rounded p-2 flex justify-between">
              <span>{a.reference} — {a.name}</span>
              <span className="text-gray-500">disponibles: {a.available_units}</span>
            </li>
          ))}
        </ul>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Crear alquiler</h2>
        <form onSubmit={createRental} className="space-y-3">
          <select className="w-full border rounded p-2" value={organizerId} onChange={e => setOrganizerId(e.target.value)}>
            <option value="">Seleccione organizador</option>
            {organizers.map(o => <option key={o.id} value={o.id}>{o.full_name}</option>)}
          </select>
          <select className="w-full border rounded p-2" value={articleId} onChange={e => setArticleId(e.target.value)}>
            <option value="">Seleccione artículo</option>
            {articles.map(a => <option key={a.id} value={a.id}>{a.reference} — {a.name}</option>)}
          </select>
          <input className="w-full border rounded p-2" type="number" min="1" value={quantity} onChange={e => setQuantity(e.target.value)} />
          <button className="bg-blue-600 text-white rounded p-2">Crear alquiler</button>
        </form>
      </section>
    </div>
  )
}
