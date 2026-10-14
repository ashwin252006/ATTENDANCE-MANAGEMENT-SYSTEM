import { Link } from 'react-router-dom';

export default function Unauthorized() {
  return (
    <div className="text-center py-12">
      <h1 className="text-4xl font-bold text-red-600">403</h1>
      <p className="mt-2 text-gray-600">You are not authorized to view this page.</p>
      <Link to="/dashboard" className="mt-4 inline-block text-blue-600 hover:underline">Back to Dashboard</Link>
    </div>
  );
}