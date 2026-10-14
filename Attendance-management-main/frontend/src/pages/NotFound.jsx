import { Link } from 'react-router-dom';

export default function NotFound() {
  return (
    <div className="text-center py-12">
      <h1 className="text-6xl font-bold text-gray-300">404</h1>
      <p className="mt-2 text-gray-600">Page not found</p>
      <Link to="/dashboard" className="mt-4 inline-block text-blue-600 hover:underline">Go to Dashboard</Link>
    </div>
  );
}