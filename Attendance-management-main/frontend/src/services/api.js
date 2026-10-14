import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  withCredentials: true
});

api.interceptors.response.use(
  r => r,
  async error => {
    const original = error.config;
    if (error.response?.status === 401 && !original._retry) {
      original._retry = true;
      try {
        await axios.post(`${import.meta.env.VITE_API_BASE_URL}/auth/refresh`, {}, { withCredentials: true });
        return api(original);
      } catch (_) { }
    }
    return Promise.reject(error);
  }
);

export default api;