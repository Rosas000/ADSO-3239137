const BASE = import.meta.env.VITE_API_URL || 'http://localhost:8000/api/v1'

let token = localStorage.getItem('token') || null

export function setToken(t) {
  token = t
  localStorage.setItem('token', t)
}

export function getToken() {
  return token
}

export async function request(method, path, body) {
  const res = await fetch(BASE + path, {
    method,
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      ...(token ? { Authorization: 'Bearer ' + token } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  })
  const data = await res.json().catch(() => null)
  return { status: res.status, data }
}
