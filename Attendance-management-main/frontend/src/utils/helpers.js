export const formatDate = (iso) => new Date(iso).toLocaleDateString();
export const csvEscape = (v) => `"${String(v).replace(/"/g, '""')}"`;