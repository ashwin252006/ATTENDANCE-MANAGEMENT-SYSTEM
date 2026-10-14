import { useEffect, useState } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { Bar } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';
ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

export default function Dashboard() {
  const { user } = useAuth();
  const [stats, setStats] = useState(null);

  useEffect(() => {
    const url = user.role === 'STUDENT' ? `/attendance/student/${user.id}` : '/reports/summary';
    api.get(url).then(r => setStats(r.data)).catch(() => setStats({}));
  }, [user]);

  if (!stats) return <p className="text-center">Loading…</p>;

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold">Dashboard – {user.role}</h2>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {[
          { label: 'Total Students', value: stats.totalStudents ?? 0 },
          { label: 'Total Faculty', value: stats.totalFaculty ?? 0 },
          { label: 'Classes Conducted', value: stats.classesConducted ?? 0 },
          { label: 'Overall Attendance %', value: stats.overallPct ? `${stats.overallPct}%` : 'N/A' }
        ].map((c, i) => (
          <div key={i} className="bg-white p-4 rounded shadow">
            <p className="text-sm text-gray-500">{c.label}</p>
            <p className="text-2xl font-bold">{c.value}</p>
          </div>
        ))}
      </div>

      {stats.subjectChart && (
        <div className="bg-white p-4 rounded shadow">
          <h3 className="mb-2 font-medium">Subject‑wise Attendance</h3>
          <Bar
            data={{
              labels: stats.subjectChart.labels,
              datasets: [{
                label: 'Attendance %',
                data: stats.subjectChart.values,
                backgroundColor: 'rgba(59,130,246,0.6)'
              }]
            }}
            options={{ responsive: true, plugins: { legend: { display: false } } }}
          />
        </div>
      )}

      {user.role === 'STUDENT' && stats.records && (
        <div className="bg-white rounded shadow overflow-hidden">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Subject</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Attended</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Total</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">%</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {stats.records.map(r => (
                <tr key={r.subjectId}>
                  <td className="px-4 py-3">{r.subjectName}</td>
                  <td className="px-4 py-3">{r.attended}</td>
                  <td className="px-4 py-3">{r.total}</td>
                  <td className="px-4 py-3">{r.pct}%</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}