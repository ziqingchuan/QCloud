export function getFileType(filename) {
  const ext = filename.split('.').pop().toLowerCase();
  
  const typeMap = {
    pdf: 'pdf',
    doc: 'doc',
    docx: 'doc',
    xls: 'excel',
    xlsx: 'excel',
    ppt: 'ppt',
    pptx: 'ppt',
    jpg: 'image',
    jpeg: 'image',
    png: 'image',
    gif: 'image',
    svg: 'image',
    webp: 'image',
    zip: 'zip',
    rar: 'zip',
    '7z': 'zip',
    txt: 'txt',
    md: 'txt',
    html: 'txt',
    css: 'txt',
    js: 'txt',
    json: 'txt'
  };
  
  return typeMap[ext] || 'default';
}

export function formatFileSize(bytes) {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

export function formatDate(date) {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}`;
}
